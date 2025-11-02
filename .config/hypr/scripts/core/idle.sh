#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │                 IDLE MANAGER DAEMON              │
# └──────────────────────────────────────────────────┘

# [INFO] This script launches swayidle with configured timeouts
# [INFO] for screen locking and power management.

swayidle -w \
  timeout 300 '~/.config/hypr/scripts/core/smart_lock.sh' \
  timeout 600 'hyprctl dispatch dpms off' \
  resume 'sleep 1 && hyprctl dispatch dpms on' \
  before-sleep '~/.config/hypr/scripts/core/lockscreen.sh'
