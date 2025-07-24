#!/bin/bash

hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | awk '{print $1}' | sed 's/English/EN/' | sed 's/Russian/RU/'
