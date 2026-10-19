#!/usr/bin/env bash
set -euo pipefail

# AeroSpace can run this more than once during a config reload. A clean restart
# prevents CoreText from retaining stale Nerd Font glyph mappings.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v sketchybar >/dev/null 2>&1; then
  exit 0
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
dotfiles="$(cd "$script_dir/../../.." && pwd -P)"

pkill -x sketchybar 2>/dev/null || true
attempt=0
while pgrep -x sketchybar >/dev/null 2>&1 && [ "$attempt" -lt 20 ]; do
  sleep 0.1
  attempt=$((attempt + 1))
done

CONFIG_DIR="$script_dir" nohup sketchybar --config "$script_dir/sketchybarrc" >/dev/null 2>&1 &
"$dotfiles/scripts/start-borders.sh"
