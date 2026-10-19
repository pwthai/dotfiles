#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

host="${1:?connectivity host is required}"

set_connectivity_idle_state() {
  local item="$1"

  sketchybar --set "$item" background.drawing=off

  case "$item" in
    wifi) WIFI_STATUS_ONLY=1 "$PLUGIN_DIR/wifi.sh" ;;
    bluetooth) BLUETOOTH_STATUS_ONLY=1 "$PLUGIN_DIR/bluetooth.sh" ;;
    *) sketchybar --set "$item" icon.color="$SUBTEXT" ;;
  esac
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
