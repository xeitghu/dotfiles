#!/bin/bash

# Проверяем обновления из официальных репозиториев с помощью checkupdates
OFFICIAL_UPDATES=$(checkupdates | wc -l)

# Проверяем обновления из AUR с помощью yay
# Флаг --aur говорит yay работать только с AUR
# Флаг -Q говорит работать с локальной базой, а -u - искать обновления
AUR_UPDATES=$(yay -Qum --aur | wc -l)

# Складываем оба значения
TOTAL_UPDATES=$((OFFICIAL_UPDATES + AUR_UPDATES))

# Если общее количество обновлений больше нуля, выводим на панель
if [ "$TOTAL_UPDATES" -gt 0 ]; then
  echo " $TOTAL_UPDATES"
else
  echo ""
fi
