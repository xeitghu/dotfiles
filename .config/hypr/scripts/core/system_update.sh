#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │               System Update Script               │
# └──────────────────────────────────────────────────┘

# --- Run the system update ---
# [INFO] Using yay to update official and AUR packages
yay -Syu

# --- Check if the update was successful ---
# [INFO] $? holds the exit code of the last command. 0 means success.
if [ $? -eq 0 ]; then
  # --- Ask for reboot in a loop ---
  while true; do
    # [INFO] read -p shows a prompt, -n 1 waits for a single character
    read -p "Reboot now? (y/n) " -n 1 -r REPLY
    echo # Move to a new line

    case $REPLY in
    [Yy]*)
      systemctl reboot
      break
      ;;
    [Nn]*)
      echo "Reboot cancelled."
      break
      ;;
    *)
      echo "Invalid input. Please answer y or n."
      ;;
    esac
  done
else
  echo "Update failed. Press any key to exit."
  read -n 1 -s -r
fi
