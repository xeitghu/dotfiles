#!/bin/bash
STATE_FILE="$HOME/.config/pyre/state"
THEMES=("Mocha" "Latte" "Frappe" "Macchiato")

current_theme=$(cat "$STATE_FILE")

# Находим индекс текущей темы
for i in "${!THEMES[@]}"; do
    if [[ "${THEMES[$i]}" == "$current_theme" ]]; then
        current_index=$i
        break
    fi
done

# Вычисляем индекс следующей темы
next_index=$(( (current_index + 1) % ${#THEMES[@]} ))
next_theme=${THEMES[$next_index]}

# Вызываем основной скрипт с именем новой темы
/home/x8u/.local/bin/pyre theme "$next_theme"