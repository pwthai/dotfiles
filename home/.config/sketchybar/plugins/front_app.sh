#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

app_name="${INFO:-}"
if [ -z "$app_name" ]; then
  app_name="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || true)"
fi

case "$app_name" in
  ""|Finder) sketchybar --set "$NAME" drawing=off ;;
  *) sketchybar --set "$NAME" drawing=on label="$app_name" ;;
esac
