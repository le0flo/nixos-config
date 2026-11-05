#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="xmonad"
export XDG_SESSION_DESKTOP="xmonad"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORMTHEME="qt6ct"

xrandr --output eDP-1 --mode 1920x1080 --rate 60
xrandr --output HDMI-0 --mode 1920x1080 --rate 75
xset r rate 200 25

exec xmonad
