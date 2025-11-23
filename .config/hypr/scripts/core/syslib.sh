#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │           MAINTENANCE ACTIONS LIBRARY            │
# └──────────────────────────────────────────────────┘
# [INFO] This is a non-executable library of functions.
# [INFO] It is meant to be sourced by other scripts.

# --- Colors & Helpers ---
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;34m'
C_NC='\033[0m'
print_header() {
  printf "\n${C_BLUE}=================================================================${C_NC}\n"
  printf "${C_BLUE}  $1${C_NC}\n"
  printf "${C_BLUE}=================================================================${C_NC}\n"
}

# --- Function: System Update ---
perform_update() {
  print_header "UPDATING SYSTEM PACKAGES (yay)"

  local LOG_FILE=${PACMAN_LOG:-"/tmp/pacman_update.fallback.log"}

  sudo pacman -Syu --noconfirm --logfile "$LOG_FILE"
  if [ $? -ne 0 ]; then
    printf "${C_RED}Critical error during pacman update. Aborting.${C_NC}\n"
    return 1
  fi

  yay -Sua --sudoloop --noconfirm --logfile "$LOG_FILE"
  if [ $? -ne 0 ]; then
    printf "${C_YELLOW}Warning: AUR package update failed. Please check the log.${C_NC}\n"
  fi

  printf "${C_GREEN}Package update completed.${C_NC}\n"
}

# --- Function: System Cleanup ---
perform_cleanup() {
  print_header "PERFORMING SYSTEM CLEANUP"
  # --- Orphan Cleanup ---
  if ORPHANS=$(yay -Qdtq); then
    if [ -n "$ORPHANS" ]; then
      printf "${C_YELLOW}Removing orphan packages...${C_NC}\n"
      sudo yay -Rns --noconfirm $ORPHANS
    else
      printf "No orphan packages found.\n"
    fi
  fi
  # --- Pacman Cache Cleanup ---
  printf "\n${C_YELLOW}Cleaning pacman cache...${C_NC}\n"
  sudo paccache -rk2
  # --- Journald Cleanup ---
  printf "\n${C_YELLOW}Cleaning systemd journal...${C_NC}\n"
  sudo journalctl --vacuum-size=50M
  printf "${C_GREEN}System cleanup completed.${C_NC}\n"
}

# --- Function: Timeshift Snapshot ---
create_snapshot() {
  print_header "CREATING TIMESHIFT SNAPSHOT"
  if ! command -v timeshift &>/dev/null; then
    printf "${C_YELLOW}Timeshift not installed, skipping.${C_NC}\n"
    return 0
  fi

  # --- Create new snapshot ---
  printf "${C_YELLOW}Starting snapshot creation... This may take several minutes. Please be patient.${C_NC}\n"
  sudo timeshift --create --comments "Pre-update snapshot" --tags D --quiet
  if [ $? -eq 0 ]; then
    printf "${C_GREEN}Timeshift snapshot created successfully.${C_NC}\n"
  else
    printf "${C_RED}Snapshot creation failed or was cancelled.${C_NC}\n"
    return 1
  fi

  # --- Cleanup old snapshots ---
  printf "\n${C_YELLOW}Checking snapshot limits...${C_NC}\n"
  # [CONFIG] Maximum number of automated snapshots to keep.
  local MAX_SNAPSHOTS=5

  # [INFO] Get a machine-readable list of snapshot NAMES ONLY, then sort.
  # [FIX] This method is robust and only parses snapshot names, ignoring other output.
  local SNAPSHOT_NAMES=$(sudo timeshift --list | grep -oP '^\d+\s*>\s*\K[0-9_-]+' | sort)
  local SNAPSHOT_COUNT=$(echo "$SNAPSHOT_NAMES" | wc -l)

  if [ "$SNAPSHOT_COUNT" -gt "$MAX_SNAPSHOTS" ]; then
    local REMOVE_COUNT=$((SNAPSHOT_COUNT - MAX_SNAPSHOTS))
    printf "Snapshot limit ($MAX_SNAPSHOTS) exceeded. Removing $REMOVE_COUNT oldest snapshot(s)...\n"

    # [INFO] Loop through the oldest snapshot NAMES and delete them.
    for SNAP_NAME in $(echo "$SNAPSHOT_NAMES" | head -n "$REMOVE_COUNT"); do
      printf "Deleting old snapshot: $SNAP_NAME\n"
      sudo timeshift --delete --snapshot "$SNAP_NAME"
    done
    printf "${C_GREEN}Old snapshots removed successfully.${C_NC}\n"
  else
    printf "Snapshot count ($SNAPSHOT_COUNT) is within the limit ($MAX_SNAPSHOTS). No cleanup needed.\n"
  fi
}

# --- Function: Security Scans ---
perform_scans() {
  # --- Rkhunter ---
  print_header "RUNNING RKHUNTER SECURITY CHECK"
  if command -v rkhunter &>/dev/null; then
    sudo rkhunter --check --sk 2>/dev/null
    printf "${C_GREEN}Rkhunter scan complete.${C_NC}\n"
  else
    printf "${C_YELLOW}Rkhunter not installed, skipping.${C_NC}\n"
  fi
  # --- Lynis ---
  print_header "RUNNING LYNIS AUDIT"
  if command -v lynis &>/dev/null; then
    sudo lynis audit system
  else
    printf "${C_YELLOW}Lynis not installed, skipping.${C_NC}\n"
  fi
}
