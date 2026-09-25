# clipimg-send

A Raycast script command (and shell utility) that pushes an image or file from the macOS clipboard to a remote host over SSH, and automatically pastes the resulting remote path into the currently active window (e.g. Ghostty, iTerm2).

## Overview

When triggered via a global hotkey (e.g., `Ctrl + Cmd + V`), this script:
1. Extracts the current image from the macOS clipboard using `pngpaste` (or falls back to a file copied from Finder).
2. Uploads the file to the remote host (`nuc.tail0dcbd.ts.net`) into `~/.cache/clipimg/` via SSH.
3. Copies the remote file path (with a trailing space) to the clipboard and triggers `Cmd + V` via AppleScript into the active application.

## Prerequisites

- **pngpaste**: For capturing clipboard images
  ```bash
  brew install pngpaste
  ```
- **Tailscale & SSH**:
  - Network connectivity to `nuc.tail0dcbd.ts.net` via Tailscale.
  - Passwordless SSH authentication configured for the host.
- **Raycast**:
  - Installed (`/Applications/Raycast.app`).

## Setup

1. **Install Symlinks**:
   Run `make install-clipimg-send` (or `make install`) from the dotfiles repository root. This links the script to:
   - `~/.config/raycast/scripts/clipimg-send.sh`
   - `~/bin/clipimg-send`

2. **Configure Raycast**:
   - Open Raycast Settings (`Cmd + ,`).
   - Navigate to **Extensions** → **Script Commands**.
   - Click **Add Directories** and select `~/.config/raycast/scripts`.
   - Select **Send Clipboard Image to Remote** and assign `Ctrl + Cmd + V` as its **Hotkey**.

3. **Permissions**:
   - On the first execution, grant macOS permissions (Accessibility / System Events) when prompted.
