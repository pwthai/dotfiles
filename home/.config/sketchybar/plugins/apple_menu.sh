#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

action="${1:-}"

dismiss_menu() {
  sketchybar --set apple popup.drawing=off
}

confirm_action() {
  local title="$1"
  local message="$2"
  local button="$3"

  /usr/bin/osascript - "$title" "$message" "$button" <<'APPLESCRIPT'
on run argv
  display dialog (item 2 of argv) with title (item 1 of argv) buttons {"Cancel", item 3 of argv} default button (item 3 of argv) cancel button "Cancel" with icon caution
end run
APPLESCRIPT
}

run_confirmed_system_event() {
  local title="$1"
  local message="$2"
  local button="$3"
  local system_event="$4"

  if confirm_action "$title" "$message" "$button"; then
    dismiss_menu
    run_system_events "$system_event"
  fi
}

run_system_events() {
  local command="$1"

  /usr/bin/osascript -e "tell application \"System Events\" to $command"
}

case "$action" in
  host)
    case "${SENDER:-}" in
      mouse.clicked)
        close_custom_popups apple
        sketchybar --set apple popup.drawing=toggle
        ;;
      mouse.exited.global) dismiss_menu ;;
    esac
    ;;
  about)
    dismiss_menu
    /usr/bin/open -a "System Information"
    ;;
  settings)
    dismiss_menu
    /usr/bin/open -a "System Settings"
    ;;
  force_quit)
    if confirm_action "Force Quit Applications" "Open the native Force Quit Applications window? Unsaved work in apps you force quit can be lost." "Open Force Quit"; then
      dismiss_menu
      run_system_events "key code 53 using {option down, command down}"
    fi
    ;;
  lock)
    dismiss_menu
    "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession" -suspend
    ;;
  sleep)
    run_confirmed_system_event "Put Mac to Sleep" "Put this Mac to sleep now?" "Sleep" "sleep"
    ;;
  restart)
    run_confirmed_system_event "Restart Mac" "Restart this Mac now? Open work should be saved first." "Restart" "restart"
    ;;
  shutdown)
    run_confirmed_system_event "Shut Down Mac" "Shut down this Mac now? Open work should be saved first." "Shut Down" "shut down"
    ;;
  logout)
    run_confirmed_system_event "Log Out" "Log out of this account now? Open work should be saved first." "Log Out" "log out"
    ;;
  *)
    exit 2
    ;;
esac
