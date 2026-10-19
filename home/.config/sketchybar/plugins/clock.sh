#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

sketchybar --set clock label="$(date '+%B %-d, %Y · %-I:%M %p')"
