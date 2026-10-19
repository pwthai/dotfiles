#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

workspace="$1"
focused_workspace="${FOCUSED_WORKSPACE:-}"

if [ -z "$focused_workspace" ] && command -v aerospace >/dev/null 2>&1; then
  focused_workspace="$(aerospace list-workspaces --focused 2>/dev/null || true)"
fi

if [ "$workspace" = "$focused_workspace" ]; then
  sketchybar --set "$NAME" background.color="$PILL_ACTIVE" label.color="$PILL_ACTIVE_TEXT"
else
  sketchybar --set "$NAME" background.color=0x00000000 label.color="$PILL_IDLE_TEXT"
fi

if [ "${SENDER:-}" = "mouse.clicked" ] && command -v aerospace >/dev/null 2>&1; then
  aerospace workspace "$workspace"
fi
