#!/bin/bash

# Используем 'sensors' для извлечения температуры.
TEMP=$(sensors k10temp-pci-00c3 | grep '^Tctl:' | awk '{print $2}' | sed 's/+//;s/°C//')

# ★★★ ИЗМЕНЕНИЕ ЗДЕСЬ ★★★
# Вместо printf, мы просто отрезаем все после точки с помощью cut.
# Это надежно работает в любой системе, независимо от локали.
TEMP_INT=$(echo "$TEMP" | cut -d '.' -f 1)

# Выводим JSON для Waybar
echo "{\"text\": \" $TEMP_INT°C\", \"tooltip\": \"CPU Temperature (Tctl): $TEMP°C\"}"
