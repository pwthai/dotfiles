#!/usr/bin/env bash
set -euo pipefail

# GUI login shells do not always inherit Homebrew's path.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Borders has no reload command. Stop an existing instance before replacing it
# so repeated AeroSpace starts and config reloads cannot leave duplicate daemons.
pkill -x borders 2>/dev/null || true

attempt=0
while pgrep -x borders >/dev/null 2>&1 && [ "$attempt" -lt 20 ]; do
  sleep 0.1
  attempt=$((attempt + 1))
done

# Akane Red clearly marks focus; the quiet Deep Crimson outline
# keeps inactive windows legible without competing with the focused window.
nohup borders \
  active_color=0xffe55454 \
  inactive_color=0x337f303a \
  width=5.0 \
  >/dev/null 2>&1 &
