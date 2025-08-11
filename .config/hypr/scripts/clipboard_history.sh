#!/bin/bash

cliphist list | grep -v "binary data" | wofi --dmenu --prompt "Clipboard History" --width 60% --height 50% | cliphist decode | wl-copy
