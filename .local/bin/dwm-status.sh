#!/bin/bash

# ------------------------
# Initialize CPU values
# ------------------------
PREV_IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
PREV_TOTAL=$(awk '/^cpu / {for(i=2;i<=8;i++) sum+=$i; print sum}' /proc/stat)

# ------------------------
# Functions
# ------------------------
get_cpu_usage() {
    IDLE=$(awk '/^cpu / {print $5}' /proc/stat)
    TOTAL=$(awk '/^cpu / {for(i=2;i<=8;i++) sum+=$i; print sum}' /proc/stat)
    DIFF_IDLE=$((IDLE - PREV_IDLE))
    DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
    DIFF_USAGE=$(( (100 * (DIFF_TOTAL - DIFF_IDLE)) / DIFF_TOTAL ))
    PREV_IDLE=$IDLE
    PREV_TOTAL=$TOTAL
    echo "${DIFF_USAGE}%"
}

get_mem_usage() {
    awk '/Mem:/ {printf "%.1fG", $3/1024}' <(free -m)
}

get_temp() {
    sensors | awk '/^Package id 0:/ {gsub(/\+/, "", $4); printf "%.0f°C", $4; exit}'
}

# ------------------------
# Main loop
# ------------------------
while true; do
    CPU=$(get_cpu_usage)
    MEM=$(get_mem_usage)
    DATE=$(date '+%Y-%m-%d %H:%M')

    # Update dwm status bar
    xsetroot -name "CPU:$CPU|MEM:$MEM|$DATE"

    # Sleep 5 seconds before next update
    sleep 5
done
