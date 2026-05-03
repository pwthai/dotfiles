#!/usr/bin/env bash
set -euo pipefail

# Kill existing borders if running
pkill -x borders 2>/dev/null || true

# Start with a clean, subtle focused border
borders \
  active_color=0xff81a1c1 \
  inactive_color=0x00000000 \
  width=3.0 &
