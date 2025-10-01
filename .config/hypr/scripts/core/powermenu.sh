#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │               Power & Session Menu               │
# └──────────────────────────────────────────────────┘
# [INFO] This script displays a Wofi menu for session control
# [INFO] (lock, logout, suspend, reboot, shutdown) with a confirmation dialog
# [INFO] for critical actions.

# --- Configuration ---
# [CONFIG] Define menu entries with Nerd Font icons
lock=" Lock"
logout=" Logout"
suspend=" Suspend"
reboot=" Reboot"
shutdown=" Shutdown"

# [CONFIG] Wofi window dimensions
main_menu_width="280"
main_menu_height="210"
confirm_menu_width="280"
confirm_menu_height="100"

# --- Function: Confirmation Dialog ---
# [INFO] Shows a 'Yes/No' confirmation dialog for a given action.
# [INFO] Usage: confirm_action "Your question here"
confirm_action() {
  local question="$1"
  local confirm_options=" Yes\n No"

  local confirm_choice=$(echo -e "$confirm_options" | wofi --dmenu \
    --prompt "$question" \
    --width "$confirm_menu_width" \
    --height "$confirm_menu_height")

  if [ "$confirm_choice" == " Yes" ]; then
    return 0 # Success
  else
    return 1 # Cancelled
  fi
}

# --- Main Logic ---
# [INFO] Assemble the main menu options.
options="$lock\n$logout\n$suspend\n$reboot\n$shutdown"

# [INFO] Show the main menu.
choice=$(echo -e "$options" | wofi --dmenu \
  --prompt "Power Menu" \
  --width "$main_menu_width" \
  --height "$main_menu_height")

# [INFO] Process the user's choice.
case "$choice" in
"$lock")
  ~/.config/hypr/scripts/lockscreen.sh
  ;;
"$logout")
  if confirm_action "Are you sure?"; then
    hyprctl dispatch exit
  fi
  ;;
"$suspend")
  # [INFO] Suspend does not require confirmation by default.
  systemctl suspend
  ;;
"$reboot")
  if confirm_action "Are you sure?"; then
    systemctl reboot
  fi
  ;;
"$shutdown")
  if confirm_action "Are you sure?"; then
    systemctl poweroff
  fi
  ;;
esac
