#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │                   SCREENSHOT - OCR                 │
# └──────────────────────────────────────────────────┘

# [INFO] This script now calls the central capture engine and pipes
# the resulting image data directly into the OCR pipeline.

# --- Main Logic ---
# [INFO] 1. Call the capture engine to get cropped image data.
# [INFO] 2. Preprocess the image (scale, grayscale, normalize).
# [INFO] 3. Pipe the processed image to Tesseract for OCR.
# [INFO] 4. Pipe the recognized text to the clipboard.
# [INFO] 5. If successful, send a notification.
~/.config/hypr/scripts/screenshots/_capture.sh |
  convert - -scale 200% -colorspace Gray -normalize - |
  tesseract --oem 1 -l rus+eng stdin stdout |
  wl-copy &&
  notify-send "Text Copied" "Text from selected area has been copied." -i "edit-copy"
