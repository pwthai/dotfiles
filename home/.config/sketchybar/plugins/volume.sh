#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if handle_popup_event volume; then
  exit 0
fi

volume="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || printf '0')"
muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || printf 'false')"

if [ "$muted" = true ]; then
  sketchybar --set volume icon="$ICON_VOLUME_MUTED" label='Muted' icon.color="$OVERLAY" \
    --set volume.detail label="Muted · ${volume}%"
else
  sketchybar --set volume icon="$ICON_VOLUME" label="${volume}%" icon.color="$TEXT" \
    --set volume.detail label="Output volume · ${volume}%"
fi
