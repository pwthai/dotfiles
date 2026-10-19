#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [ "${BLUETOOTH_STATUS_ONLY:-}" != "1" ]; then
  case "${SENDER:-}" in
    mouse.entered|mouse.exited)
      exec "$PLUGIN_DIR/connectivity.sh" bluetooth
      ;;
  esac
fi

blueutil_bin="${BLUEUTIL_BIN:-$(command -v blueutil 2>/dev/null || true)}"
if [ -z "$blueutil_bin" ]; then
  sketchybar --set bluetooth icon="$ICON_BLUETOOTH" icon.color="$SUBTEXT"
  exit 0
fi

power="$($blueutil_bin --power 2>/dev/null || true)"
case "$power" in
  1|on|On) sketchybar --set bluetooth icon="$ICON_BLUETOOTH" icon.color="$BLUE" ;;
  0|off|Off) sketchybar --set bluetooth icon="$ICON_BLUETOOTH" icon.color="$OVERLAY" ;;
  *) sketchybar --set bluetooth icon="$ICON_BLUETOOTH" icon.color="$SUBTEXT" ;;
esac
