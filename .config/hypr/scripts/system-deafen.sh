#!/bin/bash

# Переключаем мут для устройства вывода (наушники/колонки)
pamixer --toggle-mute

# Переключаем мут для устройства ввода по умолчанию (микрофон)
pamixer --default-source --toggle-mute
