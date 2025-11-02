#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │                    PYRE ENGINE                   │
# └──────────────────────────────────────────────────┘

# ┌──────────────────────────────────────────────────┐
# │                 1. PATHS & SETTINGS              │
# └──────────────────────────────────────────────────┘
# [INFO] Core paths used by the engine.
WALLPAPER_DIR="$HOME/Pictures/walls"
STATE_FILE="$HOME/.config/pyre/state"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
ENGINE_THEMES_DIR="$HOME/.config/hypr/themes"
WAL_CACHE_DIR="$HOME/.cache/wal"

# ┌──────────────────────────────────────────────────┐
# │                 2. CORE FUNCTIONS                │
# └──────────────────────────────────────────────────┘

# --- Dependency Check ---
# [INFO] Verifies that all required commands and directories are present.
check_dependencies() {
  local missing=0

  # Check for required commands
  for cmd in wofi swww kitty notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
      notify-send "Pyre Error" "Required command not found: $cmd" -i "dialog-error"
      missing=1
    fi
  done

  # Check for required directories
  for dir in "$WALLPAPER_DIR" "$ENGINE_THEMES_DIR" "$SCRIPTS_DIR"; do
    if [ ! -d "$dir" ]; then
      notify-send "Pyre Error" "Required directory not found: $dir" -i "dialog-error"
      missing=1
    fi
  done

  [ "$missing" -eq 1 ] && exit 1
}

# --- Reload Services ---
# [INFO] Reloads core desktop services to apply changes.
reload_services() {
  hyprctl reload
  pkill -SIGUSR2 waybar
  pkill dunst && dunst &
}

# ┌──────────────────────────────────────────────────┐
# │                 3. LAYOUT LAUNCHERS              │
# └──────────────────────────────────────────────────┘

# --- Showcase Layout ---
launch_showcase_layout() {
  hyprctl keyword source ~/.config/hypr/layouts/showcase.conf
  sleep 0.1

  # [INFO] Launch fastfetch (center).
  kitty --title "fastfetch" \
    -o font_size=10.0 -o window_padding_width="10 10 10 0" -o scrollback_lines=0 \
    sh -c "tput civis; fastfetch; sleep infinity" &
  sleep 0.2

  # [INFO] Launch clock (top) with Blue color and no padding.
  # [CONFIG] Color codes: 1=Red, 2=Green, 3=Yellow, 4=Blue, 5=Magenta, 6=Cyan.
  kitty --title "tty-clock" -o font_size=10.0 -o window_padding_width=0 tty-clock -c -C 5 &
  sleep 0.2

  # [INFO] Launch cava (bottom) with no padding.
  kitty --title "cava" -o font_size=10.0 -o window_padding_width=0 cava &
  sleep 0.2

  # [INFO] Launch unimatrix (left) with its default color and no padding.
  kitty --title "unimatrix" -o font_size=10.0 -o window_padding_width=0 unimatrix -s 90 &
  sleep 0.2

  # [INFO] Launch pipes (right) with its default color and no padding.
  kitty --title "pipes" -o font_size=10.0 -o window_padding_width=0 pipes.sh &
}

# --- F0urth Layout ---
launch_f0urth_layout_simple() {
  local small_font_size=8
  kitty -o font_size=$small_font_size &
  sleep 0.3

  local directions=("r" "d" "l")
  for dir in "${directions[@]}"; do
    hyprctl dispatch movefocus "$dir"
    kitty -o font_size=$small_font_size &
    sleep 0.3
  done
}

# --- Dual Pane Layout ---
launch_dual_pane_layout() {
  hyprctl keyword source ~/.config/hypr/layouts/dual_pane.conf
  thunar &
  sleep 0.5
  kitty -o font_size=10.0 --title "fm-yazi" yazi &
  sleep 1
  hyprctl keyword source ~/.config/hypr/layouts/dual_pane_clear.conf
}

# ┌──────────────────────────────────────────────────┐
# │              4. THEME & WALLPAPER ENGINE         │
# └──────────────────────────────────────────────────┘

# --- Apply Theme ---
# [INFO] Applies a theme by copying config files and setting a random wallpaper.
apply_theme() {
  local theme_name_lower=$1
  local theme_name_capitalized
  theme_name_capitalized=$(echo "$theme_name_lower" | awk '{print toupper(substr($0,1,1))substr($0,2)}')

  # Copy master theme files to local application folders
  cp "$ENGINE_THEMES_DIR/hypr/$theme_name_lower.conf" "$HOME/.config/hypr/theme.conf"
  cp "$ENGINE_THEMES_DIR/waybar/$theme_name_lower.css" "$HOME/.config/waybar/theme.css"
  cp "$ENGINE_THEMES_DIR/wofi/$theme_name_lower.css" "$HOME/.config/wofi/theme.css"

  # Set a random wallpaper from the theme's wallpaper directory
  local theme_wallpaper_dir="$WALLPAPER_DIR/$theme_name_lower"
  if [ -d "$theme_wallpaper_dir" ]; then
    local wallpaper
    wallpaper=$(find "$theme_wallpaper_dir" -type f | shuf -n 1)
    [ -n "$wallpaper" ] && swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-step 90
  fi

  reload_services
  notify-send "🎨 Pyre: Theme Changed" "Palette activated: $theme_name_capitalized" -i "preferences-desktop-theme"
  echo "$theme_name_lower" >"$STATE_FILE"
}

# ┌──────────────────────────────────────────────────┐
# │                 5. MENUS & DISPATCHER            │
# └──────────────────────────────────────────────────┘

# --- Theme Menu ---
show_theme_menu() {
  # [INFO] Dynamically generate theme list by scanning the themes directory.
  local options=$(find "$ENGINE_THEMES_DIR/hypr" -name "*.conf" -exec basename {} .conf \; | awk '{print " " toupper(substr($0,1,1))substr($0,2)}')

  local choice=$(echo -e "$options" | wofi --dmenu --prompt "Select Theme:" --width 300 --height 100)

  if [ -n "$choice" ]; then
    local theme_name=$(echo "$choice" | sed -e 's/ //' | tr '[:upper:]' '[:lower:]')
    apply_theme "$theme_name"
  fi
}

# --- Layout Selection Menu ---
show_layout_menu() {
  # [FIX] Removed 'Fastfetch' as it's now part of the unified 'Showcase'.
  local options=("󰄛 Showcase" " F0urth" " Dual Pane")
  local choice

  choice=$(printf "%s\n" "${options[@]}" | wofi --dmenu --prompt "Select Layout:" --width 300 --height 130)

  # [INFO] Process the user's choice.
  case "$choice" in
  "󰄛 Showcase")
    (launch_showcase_layout) &
    ;;
  " F0urth")
    (launch_f0urth_layout_simple) &
    ;;
  " Dual Pane")
    (launch_dual_pane_layout) &
    ;;
  esac
}

# --- Session Menu (Power + Lock) ---
show_session_menu() {
  local options=" Power\n Lock"
  local choice
  choice=$(printf "%b" "$options" | wofi --dmenu --prompt "Session Control:" --width 300 --height 100)

  case "$choice" in
  " Power") "$SCRIPTS_DIR/powermenu.sh" ;;
  " Lock") "$SCRIPTS_DIR/lockscreen.sh" ;;
  esac
}

# --- Tools Menu (Screenshot + Clipboard) ---
show_tools_menu() {
  local options=" Screenshot\n Clipboard"
  local choice
  choice=$(printf "%b" "$options" | wofi --dmenu --prompt "Tools:" --width 300 --height 100)

  case "$choice" in
  " Screenshot") "$SCRIPTS_DIR/screenshot.sh" ;;
  " Clipboard") "$SCRIPTS_DIR/clipboard_history.sh" ;;
  esac
}

# --- Main Menu ---
show_main_menu() {
  local state_file="$HOME/.config/pyre/main_menu_last_choice"
  local options=(" Themes" " Layouts" " Tools" "󰒃 Session")
  local menu_string

  # [INFO] Prioritize the last selected menu item for faster access.
  if [ -f "$state_file" ] && last_choice=$(<"$state_file"); then
    local other_options=$(printf "%s\n" "${options[@]}" | grep -vF -- "$last_choice")
    menu_string="$last_choice\n$other_options"
  else
    menu_string=$(printf "%s\n" "${options[@]}")
  fi

  local choice=$(echo -e "$menu_string" | wofi --dmenu --prompt "Pyre Mission Control:" --width 300 --height 170)

  if [ -n "$choice" ]; then
    echo "$choice" >"$state_file"
    case "$choice" in
    " Themes") show_theme_menu ;;
    " Layouts") show_layout_menu ;;
    " Tools") show_tools_menu ;;
    "󰒃 Session") show_session_menu ;;
    esac
  fi
}
