#!/bin/bash

dunstctl history -j | \
jq -r '.data[0][] | .summary.data + ": " + .body.data' | \
wofi --dmenu --prompt "Notifications" --width 50% --height 60%
