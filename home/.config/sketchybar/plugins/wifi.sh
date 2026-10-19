#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

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
power="${WIFI_POWER:-$(/usr/sbin/networksetup -getairportpower "$device" 2>/dev/null || true)}"

if [ "${WIFI_TEST_MODE:-}" = "1" ]; then
  wifi_is_connected "$summary"
  exit
fi

if wifi_is_connected "$summary"; then
  # Modern macOS can redact SSIDs from command output, so only advertise the
  # reliable state through color instead of exposing a stale network name.
  sketchybar --set wifi icon="$ICON_WIFI" icon.color="$BLUE"
elif [ -n "$summary" ]; then
  sketchybar --set wifi icon="$ICON_WIFI" icon.color="$OVERLAY"
else
  case "$power" in
    *"On"*) sketchybar --set wifi icon="$ICON_WIFI" icon.color="$OVERLAY" ;;
    *) sketchybar --set wifi icon="$ICON_WIFI" icon.color="$OVERLAY" ;;
  esac
fi
