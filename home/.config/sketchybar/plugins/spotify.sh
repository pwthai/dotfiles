#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

action="${1:-status}"

spotify_status() {
  /usr/bin/osascript 2>/dev/null <<'APPLESCRIPT' || true
if application "Spotify" is not running then return ""
tell application "Spotify"
  set playbackState to (player state as text)
  try
    return playbackState & "|" & (artist of current track) & "|" & (name of current track)
  on error
    return playbackState & "||"
  end try
end tell
APPLESCRIPT
}

spotify_action() {
  /usr/bin/osascript - "$1" 2>/dev/null <<'APPLESCRIPT'
on run argv
  if application "Spotify" is running then
    tell application "Spotify"
      if item 1 of argv is "previous" then
        previous track
      else if item 1 of argv is "playpause" then
        playpause
      else if item 1 of argv is "next" then
        next track
      end if
    end tell
  end if
end run
APPLESCRIPT
}

update_spotify() {
  local status state artist track label control_icon control_label

  status="$(spotify_status)"
  IFS='|' read -r state artist track <<EOF
$status
EOF

  if [ -z "$state" ]; then
    sketchybar --set spotify icon.color="$SUBTEXT" label.drawing=off \
      --set spotify.detail label="Spotify unavailable" \
      --set spotify.playpause icon="$ICON_PLAY" label="Play"
    return
  fi

  if [ "$state" = "stopped" ]; then
    sketchybar --set spotify icon.color="$SUBTEXT" label.drawing=off \
      --set spotify.detail label="Spotify idle" \
      --set spotify.playpause icon="$ICON_PLAY" label="Play"
    return
  fi

  label="$artist — $track"
  control_icon="$ICON_PAUSE"
  control_label="Pause"
  if [ "$state" = "paused" ]; then
    control_icon="$ICON_PLAY"
    control_label="Play"
  fi

  sketchybar --set spotify icon.color="$GREEN" label="$label" label.drawing=on \
    --set spotify.detail label="$label" \
    --set spotify.playpause icon="$control_icon" label="$control_label"
}

case "$action" in
  previous|playpause|next)
    spotify_action "$action"
    update_spotify
    ;;
  status)
    if handle_popup_event spotify; then
      exit 0
    fi
    update_spotify
    ;;
  *)
    exit 2
    ;;
esac
