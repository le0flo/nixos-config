#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="windowmaker"
export XDG_SESSION_DESKTOP="windowmaker"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORMTHEME="qt6ct"

xrandr --output eDP-1 --mode 1920x1080 --rate 60
xrandr --output HDMI-0 --mode 1920x1080 --rate 75
xset r rate 200 25

systemctl --user import-environment XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd XDG_CURRENT_DESKTOP
systemctl --user restart xdg-desktop-portal

cputnik & disown
wmacpi & disown
wmclockmon -lc lightblue -bl & disown
wmnd -I internal & disown
wmpulsemixer -w & disown
wmsystemtray & disown

exec wmaker
