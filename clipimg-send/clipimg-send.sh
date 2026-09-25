#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Send Clipboard Image to Remote
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖼️
# @raycast.packageName Terminal Utilities
# @raycast.description Push clipboard image to remote host via ssh and paste path

# clipimg-send <remote-host>
#
# Push the current macOS clipboard image (or file, if it was Cmd+C'd from
# Finder) to <remote-host> over SSH, then copy the resulting remote path to
# clipboard and paste it into the active window (Ghostty, etc.).

set -euo pipefail

# Ensure Homebrew and standard paths are included
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Configuration (can be overridden via environment variables)
HOST="${CLIPIMG_HOST:-${1:-nuc.tail0dcbd.ts.net}}"
REMOTE_DIR="${CLIPIMG_REMOTE_DIR:-\$HOME/.cache/clipimg}"
RETENTION_DAYS="${CLIPIMG_RETENTION_DAYS:-7}"
CONNECT_TIMEOUT=5

# Create a safe temporary directory compatible with both BSD and GNU mktemp
tmp_dir="$(mktemp -d -t clipimg.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT

notify() {
  osascript -e "display notification \"$1\" with title \"clipimg-send\"" >/dev/null 2>&1 || true
}

# 1. Try a raster image first from the clipboard
tmp_img="$tmp_dir/clipboard.png"
if pngpaste "$tmp_img" 2>/dev/null; then
  src="$tmp_img"
  ext="png"
else
  # 2. Fall back to a Finder file copy (Cmd+C on a file)
  furl="$(osascript -e 'try
    POSIX path of (the clipboard as «class furl»)
  end try' 2>/dev/null || true)"

  if [ -z "$furl" ] || [ ! -f "$furl" ]; then
    notify "Clipboard has no image or file"
    exit 0
  fi

  src="$furl"
  filename="$(basename "$furl")"
  ext="${filename##*.}"
  [ "$ext" = "$filename" ] && ext="bin"
fi

name="$(date '+%Y%m%d-%H%M%S')-$$.${ext}"

# 3. Transfer file to remote host with connection timeout
remote_path="$(ssh -o BatchMode=yes -o ConnectTimeout="$CONNECT_TIMEOUT" "$HOST" "
  set -eu
  remote_dir=\"$REMOTE_DIR\"
  mkdir -p \"\$remote_dir\"
  cat > \"\$remote_dir/$name\"
  ( find \"\$remote_dir\" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null & )
  printf '%s/%s' \"\$remote_dir\" '$name'
" < "$src" 2>/dev/null)" || {
  notify "Transfer to $HOST failed (unreachable or auth error)"
  exit 1
}

if [ -z "$remote_path" ]; then
  notify "Transfer to $HOST failed"
  exit 1
fi

# 4. Copy to clipboard and paste to active window
printf '%s ' "$remote_path" | pbcopy
sleep 0.05
osascript -e 'tell application "System Events" to keystroke "v" using {command down}'


