#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if handle_popup_event battery; then
  exit 0
fi

battery_info="$(pmset -g batt 2>/dev/null || true)"
percentage="$(printf '%s\n' "$battery_info" | /usr/bin/awk 'match($0, /[0-9]+%/) { print substr($0, RSTART, RLENGTH); exit }')"

[ -n "$percentage" ] || percentage='--'

case "$battery_info" in
  *charging*|*AC\ Power*)
    sketchybar --set battery icon="$ICON_BATTERY_CHARGING" icon.font="$ICON_FONT" icon.color="$GREEN" label="$percentage" \
      --set battery.detail label="Charging · ${percentage}"
    ;;
  *)
    sketchybar --set battery icon="$ICON_BATTERY" icon.font="$TOP_BAR_ICON_FONT" icon.color="$TEXT" label="$percentage" \
      --set battery.detail label="Battery · ${percentage}"
    ;;
esac
