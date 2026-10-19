#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_DIR="$(cd "$PLUGIN_DIR/.." && pwd -P)"

# shellcheck source=../colors.sh
source "$CONFIG_DIR/colors.sh"
# shellcheck source=../icons.sh
source "$CONFIG_DIR/icons.sh"

close_custom_popups() {
  local active_host="$1"
  local host

  for host in apple clock volume battery spotify; do
    if [ "$host" != "$active_host" ]; then
      sketchybar --set "$host" popup.drawing=off
    fi
  done
}

handle_popup_event() {
  local host="$1"

  case "${SENDER:-}" in
    mouse.clicked)
      close_custom_popups "$host"
      sketchybar --set "$host" popup.drawing=toggle
      return 0
      ;;
    mouse.exited.global)
      sketchybar --set "$host" popup.drawing=off
      return 0
      ;;
  esac

  return 1
}

open_settings_pane() {
  local host="$1"
  local settings_url="$2"

  sketchybar --set "$host" popup.drawing=off
  /usr/bin/open "$settings_url"
}
