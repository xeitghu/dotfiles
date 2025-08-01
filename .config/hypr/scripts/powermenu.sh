#!/bin/bash

options=" Logout\n Suspend\n Reboot\n Shutdown"

choice=$(printf "%b" "$options" | wofi --dmenu --prompt "Power Menu" --width 280 --height 170)

case "$choice" in
    " Logout")
        hyprctl dispatch exit
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
esac
