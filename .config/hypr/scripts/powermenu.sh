choice=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 280 --height 220)

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
