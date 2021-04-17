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
