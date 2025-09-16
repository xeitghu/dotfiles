#!/bin/bash
# Определяем текущий layout
layout=$(hyprctl -j getoption general:layout | jq -r '.value')

if [ "$layout" = "master" ]; then
  # Для master layout меняем ориентацию стека
  hyprctl dispatch layoutmsg orientationnext
else
  # Для dwindle меняем split текущего контейнера
  hyprctl dispatch layoutmsg togglesplit
fi
