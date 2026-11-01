# --- Claude Code aware fzf helpers ----------------------------------------
# tmuxjump lives here (not zshrc) because tmux.conf invokes it as
# `zsh -c tmuxjump`, a non-interactive shell that sources zshenv but never
# zshrc. The shared helpers live here too so fzf-select-worktree (a zle
# widget, defined in zshrc since it needs an interactive shell) can reuse
# them -- zshenv always loads before zshrc.

# print the length of the longest argument (for sizing a printf column)
function _col_width() {
  local s n=0
  for s in "$@"; do (( ${#s} > n )) && n=${#s}; done
  print -r -- "$n"
}

# pipe tab-delimited "label\thidden..." rows through the standard picker
# (ansi colors, exact substring match, unsorted, only field 1 visible) and
# print the selected row, or nothing if cancelled
function _fzf_pick() {
  print -l -- "$@" | fzf --ansi --exact --reverse --no-sort --delimiter=$'\t' --with-nth=1
}

# set REPLY to a comma-separated list of any of "$@" not found on PATH;
# return status 0 iff everything is present. Reporting is left to the
# caller since tmuxjump and fzf-select-worktree use different channels.
function _claude_missing_commands() {
  local c
  local -a missing
  for c in "$@"; do
    (( $+commands[$c] )) || missing+=("$c")
  done
  REPLY=${(j:, :)missing}
  [[ -z "$REPLY" ]]
}

# populate _claude_status[cwd] / _claude_waiting[cwd] from every *live*
# claude session (skips stale registry entries whose pid is no longer
# running)
typeset -gA _claude_status _claude_waiting
typeset -g _claude_status_loaded=""

# drop the cached status so the next _claude_status_marker call reloads it;
# call once per picker invocation instead of refreshing unconditionally up
# front, so a picker with no claude panes/worktrees never forks jq at all
function _claude_status_invalidate() { _claude_status_loaded="" }

function _claude_live_status_refresh() {
  _claude_status=() _claude_waiting=()
  _claude_status_loaded=1

  local -a sfs
  sfs=($HOME/.claude/sessions/*.json(N.om))
  (( ${#sfs} )) || return

  local line pid cwd st wf
  for line in ${(f)"$(jq -r '[.pid // "", .cwd // "", .status // "", .waitingFor // ""] | @tsv' "${sfs[@]}" 2>/dev/null)"}; do
    pid=${line%%$'\t'*}; line=${line#*$'\t'}
    cwd=${line%%$'\t'*}; line=${line#*$'\t'}
    st=${line%%$'\t'*}
    wf=${line#*$'\t'}
    [[ -n "$pid" && -n "$cwd" ]] || continue
    kill -0 "$pid" 2>/dev/null || continue
    # sfs is newest-mtime-first, so the first entry seen per cwd is the
    # most recent live session -- skip any older duplicates
    (( ${+_claude_status[$cwd]} )) && continue
    _claude_status[$cwd]=$st
    _claude_waiting[$cwd]=$wf
  done
}

# set REPLY to a colored status marker for a cwd (empty if no live claude
# session matches it -- the caller decides what to show as its own
# fallback), lazily refreshing the status tables on first use
function _claude_status_marker() {
  [[ -n "$_claude_status_loaded" ]] || _claude_live_status_refresh
  local cwd=$1 st=${_claude_status[$1]} wf icon
  REPLY=""
  case "$st" in
    waiting)
      wf=${_claude_waiting[$cwd]}
      case "$wf" in
        "permission prompt") icon="✋" ;;
        "input needed")      icon="💬" ;;
        *)                   icon="❓" ;;
      esac
      REPLY=$'\e[31;1m'"$icon"$'\e[0m'
      ;;
    busy) REPLY=$'\e[2m● busy\e[0m' ;;
    idle) REPLY=$'\e[2m○ idle\e[0m' ;;
  esac
}

# populate the _claude_pane_* tables, keyed by tmux pane id, from every
# *live* claude session. Keyed by the registry's "tmux" field
# ("<session>:@<window>.%<pane>") instead of cwd, so two sessions that run
# in the same directory keep their own status.
typeset -gA _claude_pane_name _claude_pane_name_source _claude_pane_status \
  _claude_pane_waiting _claude_pane_since _claude_pane_sid

function _claude_pane_sessions() {
  _claude_pane_name=() _claude_pane_name_source=() _claude_pane_status=()
  _claude_pane_waiting=() _claude_pane_since=() _claude_pane_sid=()

  local -a sfs
  sfs=($HOME/.claude/sessions/*.json(N.om))
  (( ${#sfs} )) || return

  local line pane
  local -a f
  for line in ${(f)"$(jq -r '[.pid // "", .tmux // "", .name // "", .nameSource // "", .status // "", .waitingFor // "", .statusUpdatedAt // 0, .sessionId // ""] | @tsv' "${sfs[@]}" 2>/dev/null)"}; do
    f=("${(@ps:\t:)line}")
    pane=${f[2]##*.}
    [[ -n "${f[1]}" && "$pane" == %* ]] || continue
    kill -0 "${f[1]}" 2>/dev/null || continue
    # sfs is newest-mtime-first, so the first entry seen per pane is the
    # most recent live session -- skip any older duplicates
    (( ${+_claude_pane_status[$pane]} )) && continue
    _claude_pane_name[$pane]=${f[3]}
    _claude_pane_name_source[$pane]=${f[4]}
    _claude_pane_status[$pane]=${f[5]}
    _claude_pane_waiting[$pane]=${f[6]}
    _claude_pane_since[$pane]=$(( ${f[7]} / 1000 ))
    _claude_pane_sid[$pane]=${f[8]}
  done
}

# set REPLY to one line of what session $1 said last: the first line of its
# last reply that is not blank, a heading, or a code fence. The transcript
# stores each content block on its own line, so grep finds the last text
# block in the tail cheaply; jq then drops any line that only mentions those
# strings, and the line cut in half by tail (fromjson?).
function _claude_last_message() {
  local sid=$1
  REPLY=""

  local -a tfs
  tfs=($HOME/.claude/projects/*/$sid.jsonl(N))
  (( ${#tfs} )) || return

  local out
  out=$(tail -c 2000000 "${tfs[1]}" | grep -F '"type":"assistant"' | grep -F '"type":"text"' | tail -n 5 \
    | jq -nRr '[inputs | fromjson? | select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text] | last // empty' 2>/dev/null)

  local l
  for l in ${(f)out}; do
    [[ -z "${l//[[:space:]]/}" || "$l" == '#'* || "$l" == '```'* ]] && continue
    l=${l#- }
    l=${l//\*\*/}
    REPLY=${l//\`/}
    return
  done
}

# set REPLY to the question pane $1 shows above its numbered choices (an
# AskUserQuestion question, or "Do you want to proceed?" for a permission
# prompt), or nothing when no choices are on screen. Read from the screen
# because the transcript gets the pending tool call only after it is
# answered. The choices are found the way tmux-claude-watch finds them.
function _claude_pane_question() {
  setopt local_options extended_glob
  REPLY=""

  local -a lines
  lines=("${(@f)$(tmux capture-pane -p -t "$1" 2>/dev/null | tail -n 40)}")

  local i j l
  for (( i = 1; i <= ${#lines}; i++ )); do
    [[ "${lines[$i]}" == [[:space:]]#❯[[:space:]]##[0-9]##.* ]] || continue
    for (( j = i - 1; j >= 1; j-- )); do
      l=${${lines[$j]##[[:space:]│]#}%%[[:space:]│]#}
      [[ -n "$l" ]] || continue
      REPLY=$l
      return
    done
  done
}

# set REPLY to $1 cut to at most $2 display columns (a wide character counts
# as two), ending in "…" when it had to be cut
function _trunc_width() {
  local s=$1 w=$2
  if (( ${(m)#s} <= w )); then
    REPLY=$s
    return
  fi
  s=${s[1,w]}
  while (( ${(m)#s} > w - 1 )); do s=${s[1,-2]}; done
  REPLY="$s…"
}

# set REPLY to how long ago epoch second $1 was, like `claude agents` shows it
function _fmt_age() {
  local d=$(( EPOCHSECONDS - $1 ))
  if (( d < 60 )); then REPLY="now"
  elif (( d < 3600 )); then REPLY="$(( d / 60 ))m"
  elif (( d < 86400 )); then REPLY="$(( d / 3600 ))h"
  else REPLY="$(( d / 86400 ))d"
  fi
}

# print the rows tmuxjump picks from: a header line with the counts, then one
# "label\tpane-id" row per pane, grouped like `claude agents` (Needs input,
# Working, Idle; newest status change first) with every non-claude pane
# under Other. Group headings have an empty pane id. $1 is the width to fill
# (default: the terminal's).
function _tmuxjump_rows() {
  emulate -L zsh
  zmodload -F zsh/datetime p:EPOCHSECONDS

  local cols=$1
  if (( ! cols )); then
    cols=${${(s: :)"$(stty size </dev/tty 2>/dev/null)"}[2]}
    (( cols )) || cols=120
  fi

  _claude_pane_sessions

  local -a fields=(
    '#{pane_id}'
    '#{session_name}:#{window_index}#{?#{>:#{window_panes},1},.#{pane_index},}'
    '#{pane_current_command}'
    '#{pane_current_path}'
    '#{pane_title}'
  )
  local -a plines
  plines=("${(@f)$(tmux list-panes -a -F "${(pj:\t:)fields}")}")

  # pass 1: parse each pane into its group, name, and summary
  local REPLY line id coord cmd ppath title st group name summary age
  local -a p_id p_coord p_group p_name p_summary p_age p_since
  for line in $plines; do
    id=${line%%$'\t'*}; line=${line#*$'\t'}
    coord=${line%%$'\t'*}; line=${line#*$'\t'}
    cmd=${line%%$'\t'*}; line=${line#*$'\t'}
    ppath=${line%%$'\t'*}; line=${line#*$'\t'}
    title=$line
    age="" summary=""

    if [[ "$cmd" == "claude" ]]; then
      # strip Claude Code's own leading status glyph ("<glyph> text" -> "text")
      title=${title#* }
      st=${_claude_pane_status[$id]}
      case "$st" in
        waiting) group=1 ;;
        busy|shell) group=2 ;;
        *) group=3 ;;
      esac
      # a "derived" name comes from the worktree directory
      # (typed-prancing-catmull-3d), so the title says more about the task
      name=${_claude_pane_name[$id]}
      [[ -z "$name" || "${_claude_pane_name_source[$id]}" == derived ]] && name=${title:-$name}
      if [[ -n "${_claude_pane_sid[$id]}" ]]; then
        REPLY=""
        [[ "$st" == waiting ]] && _claude_pane_question "$id"
        if [[ -n "$REPLY" ]]; then
          [[ "${_claude_pane_waiting[$id]}" == "permission prompt" ]] && REPLY="permission: $REPLY"
        else
          _claude_last_message "${_claude_pane_sid[$id]}"
        fi
        summary=$REPLY
        _fmt_age "${_claude_pane_since[$id]}"
        age=$REPLY
      fi
      [[ "$st" == shell ]] && summary="shell  $summary"
    else
      group=4
      name=${ppath:t}
      summary="$cmd  $title"
    fi

    p_id+=("$id")
    p_coord+=("$coord")
    p_group+=("$group")
    p_name+=("$name")
    p_summary+=("$summary")
    p_age+=("$age")
    p_since+=("${_claude_pane_since[$id]:-0}")
  done

  # column widths: the name is capped so the summary keeps most of the row;
  # fzf takes 3 columns for its pointer, marker, and scrollbar
  local i namew=0 coordw=0
  for (( i = 1; i <= ${#p_id}; i++ )); do
    (( ${(m)#p_name[$i]} > namew )) && namew=${(m)#p_name[$i]}
    (( ${#p_coord[$i]} > coordw )) && coordw=${#p_coord[$i]}
  done
  (( namew > 32 )) && namew=32
  local sumw=$(( cols - 3 - 3 - namew - 2 - 2 - coordw - 2 - 4 ))
  (( sumw < 10 )) && sumw=10

  # pass 2: render group by group
  local -a headings=("Needs input" "Working" "Idle" "Other") counts=(0 0 0 0) order
  # the groups that need a look get a colored chip: yellow like the tab of a
  # session waiting for input, blue for the ones still running
  local -a hstyles=($'\e[30;43;1m' $'\e[97;44;1m' $'\e[1m' $'\e[1m')
  local g k marker dim=$'\e[2m' reset=$'\e[0m'
  local -a out
  for (( g = 1; g <= 4; g++ )); do
    order=()
    for (( i = 1; i <= ${#p_id}; i++ )); do
      (( p_group[$i] == g )) && order+=("${p_since[$i]} $i")
    done
    (( ${#order} )) || continue
    counts[$g]=${#order}
    # Other keeps tmux's order; claude sessions show the newest change first
    (( g < 4 )) && order=("${(@On)order}")

    out+=("${hstyles[$g]} ${headings[$g]} $reset	")
    for k in $order; do
      i=${k#* }
      marker="$dim·$reset"
      if (( g == 1 )); then
        # red for a permission prompt and yellow otherwise, like the tab colors
        [[ "${_claude_pane_waiting[${p_id[$i]}]}" == "permission prompt" ]] \
          && marker=$'\e[31m*'"$reset" || marker=$'\e[33m*'"$reset"
      fi
      _trunc_width "${p_name[$i]}" $namew; name=$REPLY
      _trunc_width "${p_summary[$i]}" $sumw; summary=$REPLY
      out+=(" $marker ${(mr:$namew:)name}  ${(mr:$sumw:)summary}  $dim${(r:$coordw:)p_coord[$i]}  ${(l:4:)p_age[$i]}$reset	${p_id[$i]}")
    done
  done

  print -r -- "${counts[1]} awaiting input · ${counts[2]} working · ${counts[3]} idle	"
  print -rl -- "${out[@]}"
}

# list every pane across tmux sessions (splits included) and jump to one
function tmuxjump() {
  emulate -L zsh
  setopt no_aliases

  local REPLY
  if ! _claude_missing_commands tmux fzf jq; then
    print -u2 -- "tmuxjump: command not found: $REPLY"
    print -u2 -- "(PATH is missing entries that zshrc sets; the tmux server may have been started without them)"
    return 1
  fi

  # not _fzf_pick: the first row is a header, and the cursor starts on the
  # first session instead of the heading above it
  local selected
  selected=$(_tmuxjump_rows | fzf --ansi --exact --reverse --no-sort --delimiter=$'\t' --with-nth=1 \
    --header-lines=1 --highlight-line --bind 'load:pos(2)')

  # empty when cancelled or when a group heading was picked
  local id=${selected##*$'\t'}
  [[ -n "$id" ]] || return 0

  local here there client
  here=$(tmux display-message -p '#{session_name}')
  there=$(tmux display-message -p -t "$id" '#{session_name}')
  client=$(tmux display-message -p '#{client_name}')

  if [[ "$there" == popup && "$here" != popup ]]; then
    # switching this client to the popup session would show it outside the
    # popup: pick the pane inside that session and reopen the popup instead,
    # once this picker's own popup has closed
    tmux select-window -t "$id" \; select-pane -t "$id"
    local -a reply
    _tmuxpopup_args
    tmux run-shell -b "sleep 0.2; tmux popup -c ${(qq)client} ${(j: :)${(@qq)reply}}"
  elif [[ "$here" == popup && "$there" != popup ]]; then
    # from inside the popup, show the pane in the client the popup is
    # drawn over (the most recently active one outside the popup session),
    # then close the popup
    local outer
    outer=${${(f)"$(tmux list-clients -F '#{client_activity} #{client_name} #{client_session}' | grep -v ' popup$' | sort -rn)"}[1]}
    outer=${${(s: :)outer}[2]}
    tmux switch-client -c "$outer" -t "$id" \; select-window -t "$id" \; select-pane -t "$id" \; detach-client -t "$client"
  else
    tmux switch-client -t "$id" \; select-window -t "$id" \; select-pane -t "$id"
  fi
}

# set reply to the arguments of the popup that shows the "popup" session,
# shared with tmuxjump, which reopens it after jumping to one of its panes
function _tmuxpopup_args() {
  local width="80%"
  local height="80%"

  reply=(-d '#{pane_current_path}' -xC -yC "-w${width}" "-h${height}" -E "tmux attach -t popup || tmux new -s popup")
}

# tmux popup
function tmuxpopup() {
  if [[ "$(tmux display-message -p -F "#{session_name}")" = "popup" ]]; then
    tmux detach-client
  else
    local -a reply
    _tmuxpopup_args
    tmux popup "${reply[@]}"
  fi
}
