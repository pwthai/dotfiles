#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [ "${WIFI_STATUS_ONLY:-}" != "1" ]; then
  case "${SENDER:-}" in
    mouse.entered|mouse.exited)
      exec "$PLUGIN_DIR/connectivity.sh" wifi
      ;;
  esac
fi

wifi_is_connected() {
  local summary="$1"

  case "$summary" in
    *"InterfaceType : WiFi"*) ;;
    *) return 1 ;;
  esac

  case "$summary" in
    *"LinkStatusActive : TRUE"*) return 0 ;;
    *) return 1 ;;
  esac
}

device="en0"
summary="${WIFI_SUMMARY:-$(/usr/sbin/ipconfig getsummary "$device" 2>/dev/null || true)}"

if wifi_is_connected "$summary"; then
  sketchybar --set wifi icon="$ICON_WIFI" icon.color="$BLUE"
else
  sketchybar --set wifi icon="$ICON_WIFI" icon.color="$OVERLAY"
fi
