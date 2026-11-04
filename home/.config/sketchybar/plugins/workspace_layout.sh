#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

focused_workspace() {
  command -v aerospace >/dev/null 2>&1 || return 1

  aerospace list-workspaces --focused 2>/dev/null
}

workspace_root_layout() {
  command -v aerospace >/dev/null 2>&1 || return 1

  aerospace list-workspaces --focused \
    --format '%{workspace-root-container-layout}' 2>/dev/null
}

workspace_window_id() {
  local workspace="$1"

  command -v aerospace >/dev/null 2>&1 || return 1
  aerospace list-windows --workspace "$workspace" --format '%{window-id}' 2>/dev/null |
    while IFS= read -r window_id; do
      if [ -n "$window_id" ]; then
        printf '%s\n' "$window_id"
        return 0
      fi
    done
}

render_layout() {
  local workspace="$1"
  local layout="$2"

  case "$layout" in
    h_tiles|v_tiles)
      sketchybar --set "$NAME" icon="$ICON_LAYOUT_TILES" label="$workspace Tiles" \
        icon.color="$GREEN" label.color="$TEXT"
      ;;
    h_accordion|v_accordion)
      sketchybar --set "$NAME" icon="$ICON_LAYOUT_STACK" label="$workspace Stack" \
        icon.color="$LAVENDER" label.color="$TEXT"
      ;;
    *)
      sketchybar --set "$NAME" icon="$ICON_LAYOUT_TILES" label="$workspace Layout" \
        icon.color="$SUBTEXT" label.color="$SUBTEXT"
      ;;
  esac
}

toggle_workspace_root_layout() {
  local layout="$1"
  local workspace="$2"
  local target_layout window_id

  case "$layout" in
    h_accordion|v_accordion)
      target_layout="h_tiles"
      ;;
    h_tiles|*)
      target_layout="h_accordion"
      ;;
  esac

  window_id="$(workspace_window_id "$workspace" || true)"
  [ -n "$window_id" ] || return 0

  # AeroSpace 0.20 targets a workspace root layout through one of its windows.
  aerospace layout --window-id "$window_id" "$target_layout" 2>/dev/null || return 0
  sketchybar --trigger aerospace_workspace_layout_change
}

workspace="$(focused_workspace || true)"
layout="$(workspace_root_layout || true)"

if [ "${SENDER:-}" = "mouse.clicked" ] && [ -n "$workspace" ] && [ -n "$layout" ]; then
  toggle_workspace_root_layout "$layout" "$workspace"
  layout="$(workspace_root_layout || true)"
fi

render_layout "$workspace" "$layout"
