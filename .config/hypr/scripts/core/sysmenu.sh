#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │            INTERACTIVE MAINTENANCE MENU          │
# └──────────────────────────────────────────────────┘
# [INFO] This script provides a menu to run maintenance tasks individually.

# [INFO] Source the shared library with all the logic.
source "$(dirname "$0")/syslib.sh"

# --- Main Menu Loop ---
while true; do
  clear
  print_header "SYSTEM MAINTENANCE"
  echo " [1] System Update"
  echo " [2] System Cleanup (Orphans, Cache)"
  echo " [3] Create Timeshift Snapshot"
  echo " [4] Run Security Scans"
  echo " [A] All of the above"
  echo " [Q] Quit"
  echo ""
  read -p " Enter selection: " choice

  case "$choice" in
  1) perform_update ;;
  2) perform_cleanup ;;
  3) create_snapshot ;;
  4) perform_scans ;;
  [Aa])
    create_snapshot &&
      perform_update &&
      perform_cleanup &&
      perform_scans
    ;;
  [Qq]) break ;;
  *) echo -e "\n${C_RED}Invalid option. Please try again.${C_NC}" ;;
  esac

  if [[ "$choice" != [Qq] ]]; then
    echo -e "\n${C_YELLOW}Press Enter to return to the menu...${C_NC}"
    read -r
  fi
done

echo -e "\n${C_GREEN}Exiting Maintenance Menu.${C_NC}"
