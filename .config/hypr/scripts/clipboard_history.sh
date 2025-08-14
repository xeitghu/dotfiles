#!/bin/bash

cliphist list | grep -v "binary data" | wofi --dmenu --prompt "Clipboard History" --width 58% --height 30% | cliphist decode | wl-copy
