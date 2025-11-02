#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │   Advanced System Update & Security Scan Script (v2) │
# └──────────────────────────────────────────────────┘

# --- Configuration & Colors ---
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_NC='\033[0m' # No Color

# --- Function to print styled headers ---
print_header() {
  printf "\n${C_BLUE}=================================================================${C_NC}\n"
  printf "${C_BLUE}  $1${C_NC}\n"
  printf "${C_BLUE}=================================================================${C_NC}\n"
}

# --- Pre-flight check: Ensure root privileges are available ---
# [INFO] Refreshes the sudo timestamp. If invalid, prompts for password.
sudo -v
if [ $? -ne 0 ]; then
  echo -e "${C_RED}Could not obtain sudo privileges. Aborting.${C_NC}"
  read -n 1 -s -r
  exit 1
fi

# --- Step 1: System Package Update ---
print_header "UPDATING SYSTEM PACKAGES (yay)"
# [FIX] Use a single, unified command for updates.
# [INFO] '--logfile' is passed to pacman to keep the kernel check logic.
yay -Syu --sudoloop --logfile /tmp/pacman_update.log
UPDATE_STATUS=$?

# --- Check if the update was successful ---
if [ $UPDATE_STATUS -eq 0 ]; then
  printf "${C_GREEN}Package update completed successfully.${C_NC}\n"

  # --- Step 2: Update rkhunter database ---
  print_header "UPDATING RKHUNTER DATABASE"
  # [FIX] Suppress non-critical warnings from rkhunter's old scripts.
  sudo rkhunter --propupd 2>/dev/null
  printf "${C_GREEN}rkhunter database update completed.${C_NC}\n"

  # --- Step 3: Run rkhunter check ---
  print_header "RUNNING RKHUNTER SECURITY CHECK"
  sudo rkhunter --check --sk 2>/dev/null
  RKHUNTER_WARNINGS=$(sudo grep -c "\[ Warning \]" /var/log/rkhunter.log)

  # --- Step 4: Check for kernel update ---
  KERNEL_UPDATED=$(grep -E -c "upgraded (linux|linux-zen|linux-lts)" /tmp/pacman_update.log)

  # --- Step 5: Final Summary and Reboot Prompt ---
  print_header "SUMMARY"
  if [ "$RKHUNTER_WARNINGS" -gt 0 ]; then
    printf "${C_YELLOW}rkhunter found ${RKHUNTER_WARNINGS} warning(s). Review the log: /var/log/rkhunter.log${C_NC}\n"
  else
    printf "${C_GREEN}rkhunter scan found no warnings.${C_NC}\n"
  fi

  if [ "$KERNEL_UPDATED" -gt 0 ]; then
    printf "${C_YELLOW}A kernel update was detected. Reboot is strongly recommended.${C_NC}\n"
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
      sleep 2
      break
      ;;
    *)
      echo "Invalid input. Please answer y or n."
      ;;
    esac
  done
else
  printf "${C_RED}Update failed. Press any key to exit.${C_NC}\n"
  read -n 1 -s -r
fi

# [FIX] Clean up temporary log file with sudo privileges.
sudo rm -f /tmp/pacman_update.log
