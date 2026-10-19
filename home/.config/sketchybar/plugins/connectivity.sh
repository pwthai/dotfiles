#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

host="${1:?connectivity host is required}"

set_connectivity_idle_state() {
  local item="$1"

  sketchybar --set "$item" background.drawing=off

  if [ "$item" = "wifi" ]; then
    # Re-run the status updater so its connected/offline color remains truthful.
    "$PLUGIN_DIR/wifi.sh"
  else
    sketchybar --set "$item" icon.color="$SUBTEXT"
  fi
}

case "${SENDER:-}" in
  mouse.entered)
    sketchybar --set "$host" background.drawing=on background.color="$SURFACE1" \
      icon.color="$YELLOW"
    ;;
  mouse.exited)
    set_connectivity_idle_state "$host"
    ;;
  *)
    set_connectivity_idle_state "$host"
    ;;
esac
