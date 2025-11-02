#!/bin/bash
# [INFO] 'yay -Qu' lists all pending updates. 'wc -l' counts them.
TOTAL_UPDATES=$(yay -Qu | wc -l)

# [INFO] If the total count is greater than zero, display it.
# [INFO] Otherwise, output an empty string to hide the module.
if [ "$TOTAL_UPDATES" -gt 0 ]; then
  echo " $TOTAL_UPDATES"
else
  echo ""
fi
