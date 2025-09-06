#!/bin/bash

# Файл, который будет служить индикатором работы скрипта
PID_FILE="/tmp/autoclick.pid"

if [ -f "$PID_FILE" ]; then
    # Если файл существует, значит кликер работает. Убиваем его.
    kill $(cat $PID_FILE)
    rm $PID_FILE
    notify-send "Автокликер ВЫКЛЮЧЕН" -t 1000 # Уведомление на 1 секунду
else
    # Если файла нет, запускаем кликер в фоновом режиме
    notify-send "Автокликер ВКЛЮЧЕН" -t 1000

    # Бесконечный цикл кликов
    (
        # trap 'rm -f $PID_FILE' EXIT # Очистка при завершении
        while true; do
            ydotool key 272:1 272:0
            sleep 0.1
        done
    ) &

    # Сохраняем ID процесса (PID) в файл
    echo $! > $PID_FILE
fi
