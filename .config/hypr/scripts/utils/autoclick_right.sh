#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │        Autoclicker Toggle Script (Right)         │
# └──────────────────────────────────────────────────┘

# --- Variables ---
# [INFO] PID-файл для отслеживания состояния скрипта (правая кнопка)
PID_FILE="/tmp/autoclick_right.pid"

# --- Main Logic ---
if [ -f "$PID_FILE" ]; then
  # [INFO] Если PID-файл существует, кликер запущен. Останавливаем его.
  kill $(cat $PID_FILE)
  rm $PID_FILE
  notify-send "Right Autoclicker OFF" -i "process-stop" -t 1000
else
  # [INFO] Если PID-файл не существует, запускаем кликер.
  notify-send "Right Autoclicker ON" -i "input-mouse" -t 1000

  # [INFO] Запускаем цикл кликов в фоновом режиме.
  (
    # [FIX] Гарантируем удаление PID-файла при любом выходе из скрипта.
    trap 'rm -f $PID_FILE' EXIT
    while true; do
      # ИЗМЕНЕНО: 273 - это код для правой кнопки мыши
      ydotool key 273:1 273:0
      sleep 0.020
    done
  ) &

  # [INFO] Сохраняем ID процесса (PID) фоновой задачи в файл.
  echo $! >$PID_FILE
fi
