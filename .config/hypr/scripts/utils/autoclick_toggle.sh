#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │               Autoclicker Toggle Script          │
# └──────────────────────────────────────────────────┘

# --- Variables ---
# [INFO] A PID file is used to track if the script is running.
PID_FILE="/tmp/autoclick.pid"

# --- Main Logic ---
if [ -f "$PID_FILE" ]; then
  # [INFO] If the PID file exists, the clicker is running. Kill it.
  kill $(cat $PID_FILE)
  rm $PID_FILE
  notify-send "Autoclicker OFF" -i "process-stop" -t 1000
else
  # [INFO] If the PID file does not exist, start the clicker.
  notify-send "Autoclicker ON" -i "input-mouse" -t 1000

  # [INFO] Start the clicker loop in the background.
  (
    # [FIX] Ensure the PID file is removed on any script exit.
    trap 'rm -f $PID_FILE' EXIT
    while true; do
      ydotool key 272:1 272:0 # 272 is the code for the left mouse button
      sleep 0.020
    done
  ) &

  # [INFO] Save the Process ID (PID) of the background job to the file.
  echo $! >$PID_FILE
fi
