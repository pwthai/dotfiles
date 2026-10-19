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

# Use the accessibility focus source so focus tracks AeroSpace-managed windows.
# Retina rendering and a rounded 7pt Neon Sakura frame make the active edge crisp.
# Inactive borders are fully transparent so only the focused application is framed.
nohup borders \
  style=round \
  active_color=0xffff3d71 \
  inactive_color=0x007f303a \
  width=7.0 \
  hidpi=on \
  ax_focus=on \
  >/dev/null 2>&1 &
