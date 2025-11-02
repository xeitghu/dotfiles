#!/bin/bash
# ┌───────────────────────────────────┐
# │    WAYBAR - SMART WINDOW TITLE    │
# └───────────────────────────────────┘

while true; do
  ACTIVE_WINDOW_INFO=$(hyprctl activewindow -j)
  WINDOW_CLASS=$(echo "$ACTIVE_WINDOW_INFO" | jq -r '.class')

  # [CRITICAL] Check if a window is active. If not, output nothing and wait.
  if [ "$WINDOW_CLASS" = "null" ]; then
    echo "" # Outputting an empty line hides the module.
  else
    WINDOW_TITLE=$(echo "$ACTIVE_WINDOW_INFO" | jq -r '.title')
    FINAL_TEXT=""

    # --- Rules List ---
    # [CONFIG] Add your custom window titles here.
    case "$WINDOW_CLASS" in
    "kitty")
      FINAL_TEXT="kitty"
      ;;
    "obsidian")
      FINAL_TEXT="Obsidian"
      ;;
    "com.ayugram.desktop")
      FINAL_TEXT="AyuGram"
      ;;
    "zen")
      FINAL_TEXT="Zen Browser"
      ;;
    "discord")
      FINAL_TEXT="Discord"
      ;;
    "spotify")
      FINAL_TEXT="Spicetify"
      ;;
    "steam")
      FINAL_TEXT="Steam"
      ;;
    "thunar")
      FINAL_TEXT="Thunar"
      ;;
    *)
      FINAL_TEXT="$WINDOW_TITLE"
      ;;
    esac

    # --- JSON Output ---
    jq -n -c --arg text "$FINAL_TEXT" '{"text": $text}'
  fi

  # [CONFIG] This is our interval.
  sleep 0.1
done
