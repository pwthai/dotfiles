#!/usr/bin/env bash
set -euo pipefail

wallpaper="${1:-}"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: setting the wallpaper is only supported on macOS." >&2
  exit 1
fi

if ! command -v osascript >/dev/null 2>&1; then
  echo "Error: osascript is required to set the wallpaper." >&2
  exit 1
fi

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
  echo "Error: wallpaper image not found: ${wallpaper:-<not provided>}" >&2
  exit 1
fi

if ! osascript - "$wallpaper" <<'APPLESCRIPT'
on run argv
  set wallpaper to POSIX file (item 1 of argv)
  tell application "System Events"
    tell every desktop
      set picture to wallpaper
    end tell
  end tell
end run
APPLESCRIPT
then
  echo "Error: failed to set the wallpaper on all desktops." >&2
  exit 1
fi
