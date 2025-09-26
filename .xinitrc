#!/bin/sh

# Autostart
picom -b &
feh --bg-fill ~/Pictures/wallpaper.png &
dunst &
lxqt-policykit-agent &
sxhkd &

# Start dwm
~/.local/bin/dwm-status.sh &
xrandr --dpi 96 &
exec dwm
