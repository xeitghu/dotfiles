#!/bin/bash

# 1. Делаем полный скриншот для "заморозки".
grim /tmp/screenshot_full.png

# 2. Открываем его в imv как фон.
imv -f /tmp/screenshot_full.png &
IMV_PID=$!
sleep 0.3

# 3. Выделяем область поверх imv.
GEOMETRY=$(slurp)

# 4. Убиваем imv.
kill $IMV_PID
sleep 0.5

# 5. Если область не выбрана, выходим.
if [ -z "$GEOMETRY" ]; then
  rm /tmp/screenshot_full.png
  exit 0
fi

# 6. Делаем снимок области и передаем его в tesseract.
grim -g "$GEOMETRY" - | tesseract -l rus+eng stdin stdout | wl-copy

# 7. Отправляем уведомление.
notify-send "Текст скопирован" "Текст из выбранной области скопирован в буфер обмена."

# 8. Чистим временный файл.
rm /tmp/screenshot_full.png
