#!/bin/bash

TMP_FILE="/tmp/screenshot_frozen.png"

# Гарантированная очистка временного файла
trap 'rm -f "$TMP_FILE"' EXIT

# 1. Делаем полный скриншот для "заморозки".
grim "$TMP_FILE"

# 2. Открываем его в imv как фон.
imv -f "$TMP_FILE" &
IMV_PID=$!
sleep 0.3

# 3. Выделяем область поверх imv.
GEOMETRY=$(slurp)

# 4. Убиваем imv.
kill $IMV_PID

# 5. Если область не выбрана, выходим.
if [ -z "$GEOMETRY" ]; then
  exit 0
fi

# 6. Преобразуем геометрию.
CROP_GEOMETRY=$(echo "$GEOMETRY" | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')

# 7. ★★★ ГЛАВНОЕ УЛУЧШЕНИЕ ★★★
#    Вырезаем область, увеличиваем ее в 2 раза, переводим в ч/б,
#    нормализуем контраст и ТОЛЬКО ПОТОМ передаем в tesseract.
#    --oem 1 - принудительно использует самый современный движок LSTM.
convert "$TMP_FILE" -crop "$CROP_GEOMETRY" -scale 200% -colorspace Gray -normalize - |
  tesseract --oem 1 -l rus+eng stdin stdout |
  wl-copy

# 8. Отправляем уведомление.
notify-send "Text copied" "The text from the selected area has been copied to the clipboard."
