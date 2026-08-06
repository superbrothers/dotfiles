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

  _claude_status_invalidate

  local fmt='#{?#{==:#{session_name},popup},,#{pane_id}	#{session_name}:#{window_index}.#{pane_index}	#{pane_current_command}	#{pane_current_path}	#{pane_title}}'
  local -a plines
  plines=("${(@f)$(tmux list-panes -a -F "$fmt" | grep .)}")

  # pass 1: parse each pane, resolve a status marker via _claude_status_marker
  # instead of trusting Claude Code's own pane-title glyph (which only shows
  # a spinner, not *why* it's waiting)
  local line id coord cmd ppath title name marker titletext
  local -a p_id p_name p_coord p_marker p_title
  for line in $plines; do
    id=${line%%$'\t'*}; line=${line#*$'\t'}
    coord=${line%%$'\t'*}; line=${line#*$'\t'}
    cmd=${line%%$'\t'*}; line=${line#*$'\t'}
    ppath=${line%%$'\t'*}; line=${line#*$'\t'}
    title=$line

    name=${ppath:t}
    titletext=$title
    marker=$'\e[2m'"$cmd"$'\e[0m'
    if [[ "$cmd" == "claude" ]]; then
      # strip Claude Code's own leading status glyph ("<glyph> text" -> "text")
      titletext=${title#* }
      _claude_status_marker "$ppath"
      # process name always comes first, like any non-claude pane -- the
      # status marker (if any) just follows it
      [[ -n "$REPLY" ]] && marker+=" $REPLY"
    fi

    p_id+=("$id")
    p_name+=("$name")
    p_coord+=("$coord")
    p_marker+=("$marker")
    p_title+=("$titletext")
  done

  # column widths: widest name / coordinate actually present
  local namew=$(_col_width "${p_name[@]}") coordw=$(_col_width "${p_coord[@]}")

  # pass 2: render + pick
  local -a rows
  local i label
  for (( i = 1; i <= ${#p_id}; i++ )); do
    label=$(printf "%-${namew}s  %-${coordw}s  │ %s %s" "${p_name[$i]}" "${p_coord[$i]}" "${p_marker[$i]}" "${p_title[$i]}")
    rows+=("$label	${p_id[$i]}")
  done

  local selected
  selected=$(_fzf_pick "${rows[@]}")
  if [[ -z "$selected" ]]; then
    return 0
  fi

  local id=${selected##*$'\t'}
  tmux switch-client -t "$id" \; select-window -t "$id" \; select-pane -t "$id"
}

# tmux popup
function tmuxpopup() {
  local width="80%"
  local height="80%"

  if [[ "$(tmux display-message -p -F "#{session_name}")" = "popup" ]]; then
    tmux detach-client
  else
    tmux popup -d '#{pane_current_path}' -xC -yC "-w${width}" "-h${height}" -E "tmux attach -t popup || tmux new -s popup"
  fi
}
