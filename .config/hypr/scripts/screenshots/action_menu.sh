#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │            SCREENSHOT - ACTION MENU              │
# └──────────────────────────────────────────────────┘
# [INFO] This script receives a path to a temporary screenshot file
# [INFO] and presents a Wofi menu to decide its fate.

# --- Configuration ---
# [CONFIG] The base directory for all saved screenshots.
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# --- Initialization ---
# [INFO] Automatically create a sorted directory for the current month (YYYY-MM).
SORTED_DIR="$SCREENSHOT_DIR/$(date +'%Y-%m')"
mkdir -p "$SORTED_DIR"

# [INFO] Get the temporary file path from the first script argument.
TMP_FILE="$1"

# [FIX] If the file doesn't exist (e.g., capture was cancelled), exit.
if [ ! -f "$TMP_FILE" ]; then
  exit 1
fi

# --- Main Logic ---
# [INFO] Define menu options with Nerd Font icons.
options=" Save\n Copy\n Edit\n Delete"

# [CONFIG] Wofi command with correct styling and size.
wofi_command="wofi --show dmenu --prompt=Action --width 180 --height 160"

# [INFO] Display the Wofi menu and capture the user's choice.
CHOICE=$(echo -e "$options" | ${wofi_command})

# [CRITICAL] Execute the chosen action.
case "$CHOICE" in
" Save")
  FILENAME="$(date +'%Y-%m-%d_%H-%M-%S').png"
  mv "$TMP_FILE" "$SORTED_DIR/$FILENAME"
  notify-send "Screenshot Saved" "Path: $SORTED_DIR/$FILENAME"
  ;;
" Copy")
  # [FIX] Explicitly set MIME type to image/png for correct copying.
  wl-copy --type image/png <"$TMP_FILE"
  rm "$TMP_FILE"
  notify-send "Screenshot Copied" "Temporary file deleted."
  ;;
" Edit")
  swappy -f "$TMP_FILE"
  ;;
" Delete")
  rm "$TMP_FILE"
  notify-send "Screenshot Deleted"
  ;;
*)
  # [FIX] If user presses Esc in Wofi, delete the temporary file.
  rm "$TMP_FILE"
  ;;
esac
