#!/bin/bash

# Path for temporary screenshot files
IMG_ORIGINAL="/tmp/screen_original.png"
IMG_BLURRED="/tmp/screen_blurred.png"

# Take a screenshot
grim "$IMG_ORIGINAL"

# Apply a blur effect (efficient method for ImageMagick 7+)
convert "$IMG_ORIGINAL" -blur 0x8 "$IMG_BLURRED"

# Lock the screen using the blurred screenshot
swaylock -i "$IMG_BLURRED" \
  --clock \
  --indicator \
  --indicator-radius 120 \
  --indicator-thickness 8 \
  --ring-color cba6f7ee \
  --key-hl-color 89b4faee \
  --text-color cdd6f4ee \
  --font 'JetBrains Mono Nerd Font'

# Clean up temporary files after unlocking
rm "$IMG_ORIGINAL" "$IMG_BLURRED"
