#!/bin/bash

options=" Logout\n Suspend\n Reboot\n Shutdown"

choice=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 280 --height 220 | awk '{print $2}' | tr -d "[:space:]")

case "$choice" in
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
