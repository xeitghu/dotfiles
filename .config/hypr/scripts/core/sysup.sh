#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │          AUTOMATED UPDATE & SCAN SCRIPT          │
# └──────────────────────────────────────────────────┘
# [INFO] This script performs the full, safe update procedure.
# [INFO] It's intended for non-interactive use (e.g., via Waybar).

# --- Configuration ---
export PACMAN_LOG="/tmp/pacman_update.log"

# [INFO] Source the shared library with all the logic.
source "$(dirname "$0")/syslib.sh"

# --- Lock File ---
LOCK_FILE="/tmp/system_update.lock"
if [ -e "$LOCK_FILE" ]; then
  notify-send "System Update" "Update process is already running." -i "dialog-warning"
  exit 1
fi
touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# --- Execution Pipeline ---
# [INFO] Execute maintenance tasks in a safe order.
# [INFO] If any step fails (e.g., snapshot), the script will stop.
create_snapshot &&
  perform_update &&
  perform_cleanup

# --- Finalization (Reboot Prompt) ---
KERNEL_UPDATED=$(grep -E "upgraded (linux|linux-zen|linux-lts)" "$PACMAN_LOG" 2>/dev/null | wc -l)
if [ "$KERNEL_UPDATED" -gt 0 ]; then
  REBOOT_PROMPT="Kernel updated. Reboot now? (Y/n) "
  DEFAULT_REPLY="y"
else
  REBOOT_PROMPT="Reboot now? (y/n) "
  DEFAULT_REPLY="n"
fi
while true; do
  read -p "$(echo -e $REBOOT_PROMPT)" -n 1 -r REPLY
  REPLY=${REPLY:-$DEFAULT_REPLY}
  echo
  case $REPLY in
  [Yy]*)
    systemctl reboot
    break
    ;;
  [Nn]*)
    echo "Reboot cancelled."
    break
    ;;
  *) echo "Invalid input." ;;
  esac
done

# --- Cleanup ---
sudo rm -f "$PACMAN_LOG"
