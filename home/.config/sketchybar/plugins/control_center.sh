#!/usr/bin/env bash
set -euo pipefail

# Open only the main native Control Center. Individual radios and Focus are
# intentionally left untouched. Accessibility names are localized by macOS, so
# non-English systems may require the system-provided name to be adjusted.
log_file="${TMPDIR:-/tmp}/sketchybar-control-center.log"

if ! /usr/bin/osascript 2>"$log_file" <<'APPLESCRIPT'
tell application "System Events"
  tell process "ControlCenter"
    set controlCenterItem to missing value

    repeat with candidateItem in menu bar items of menu bar 1
      try
        if name of candidateItem is "Control Center" then
          set controlCenterItem to candidateItem
          exit repeat
        end if
      end try
    end repeat

    if controlCenterItem is missing value then
      repeat with candidateItem in menu bar items of menu bar 1
        try
          if name of candidateItem contains "Control Center" then
            set controlCenterItem to candidateItem
            exit repeat
          end if
        end try
      end repeat
    end if

    if controlCenterItem is missing value then
      repeat with candidateItem in menu bar items of menu bar 1
        try
          if description of candidateItem contains "Control Center" then
            set controlCenterItem to candidateItem
            exit repeat
          end if
        end try
      end repeat
    end if

    if controlCenterItem is missing value then error "Control Center menu bar item not found"
    click controlCenterItem
  end tell
end tell
APPLESCRIPT
then
  # Keep the latest TCC/Accessibility failure available without accumulating logs.
  /usr/bin/tail -c 4096 "$log_file" > "${log_file}.trimmed" 2>/dev/null || true
  /bin/mv -f "${log_file}.trimmed" "$log_file" 2>/dev/null || true
  exit 1
fi

/bin/rm -f "$log_file"
