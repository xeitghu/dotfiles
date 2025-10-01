#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │               Clipboard History Script           │
# └──────────────────────────────────────────────────┘
# [INFO] Shows clipboard history using 'cliphist' and 'wofi'.
# [INFO] This version is intentionally simple and only handles text
# [INFO] to ensure maximum stability.

# --- Main Logic ---
# 1. 'cliphist list': Get the history.
# 2. 'grep -v "binary data"': Filter out non-text entries (like images).
# 3. 'wofi --dmenu': Show the list in a selectable menu.
# 4. 'cliphist decode': Decode the selected entry.
# 5. 'wl-copy': Copy the decoded text back to the clipboard.
cliphist list | grep -v "binary data" | wofi --dmenu --prompt "Clipboard History" --width 58% --height 30% | cliphist decode | wl-copy
