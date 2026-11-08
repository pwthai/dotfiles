#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

current_mode() {
  command -v aerospace >/dev/null 2>&1 || return 1

  aerospace list-modes --current 2>/dev/null
}

set_reference_row() {
  local row="$1"
  local label="$2"
  local drawing="$3"

  sketchybar --set "aerospace_mode.reference.$row" label="$label" drawing="$drawing"
}

render_reference() {
  local mode="$1"

  case "$mode" in
    service)
      sketchybar --set aerospace_mode \
        label="SERVICE · Esc" label.color="$CRUST" \
        --set aerospace_mode_group background.color="$RED" background.border_color="$PEACH"
      set_reference_row 1 "AEROSPACE — SERVICE" on
      set_reference_row 2 "Esc          Return to Main" on
      set_reference_row 3 "R            Reset layout" on
      set_reference_row 4 "Backspace    Close other windows" on
      set_reference_row 5 "⌥⇧ H / J / K / L  Join with direction" on
      set_reference_row 6 "" off
      set_reference_row 7 "" off
      sketchybar --set aerospace_mode popup.height=29
      ;;
    *)
      sketchybar --set aerospace_mode \
        label="⌥⇧;  MAIN" label.color="$SUBTEXT" \
        --set aerospace_mode_group background.color="$MODULE_BG" background.border_color="$MODULE_BORDER"
      set_reference_row 1 "AEROSPACE — MAIN" on
      set_reference_row 2 "⌥⇧;       Service commands" on
      set_reference_row 3 "Focus       ⌥ H / J / K / L" on
      set_reference_row 4 "Move window ⌥⇧ H / J / K / L" on
      set_reference_row 5 "Resize      ⌥ − / =" on
      set_reference_row 6 "Workspace   ⌥ 1–9  ·  Move  ⌥⇧ 1–9" on
      set_reference_row 7 "Back/forth  ⌥ Tab  ·  Layout  ⌥ / ," on
      sketchybar --set aerospace_mode popup.height=29
      ;;
  esac
}

# AeroSpace dispatches on-mode-changed before list-modes always reflects the
# transition. Wait only for that event, keeping click and wake updates instant.
if [ "${SENDER:-}" = "aerospace_mode_change" ]; then
  sleep 0.3
fi

mode="$(current_mode || true)"
render_reference "$mode"

case "${SENDER:-}" in
  mouse.clicked)
    close_custom_popups "$NAME"
    sketchybar --set "$NAME" popup.drawing=toggle
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  aerospace_mode_change)
    if [ "$mode" = "service" ]; then
      close_custom_popups "$NAME"
      sketchybar --set "$NAME" popup.drawing=on
    else
      sketchybar --set "$NAME" popup.drawing=off
    fi
    ;;
esac
