#!/bin/sh

export XDG_CURRENT_DESKTOP="windowmaker"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORMTHEME="qt6ct"

systemctl --user import-environment \
    DISPLAY \
    XDG_CURRENT_DESKTOP

dbus-update-activation-environment --systemd --all

systemctl --user start windowmaker-session.target
systemctl --user start xdg-desktop-portal.service

xrandr --output eDP-1 --mode 1920x1080 --rate 60
xrandr --output HDMI-0 --mode 1920x1080 --rate 75
xset r rate 200 25

cputnik & disown
wmacpi & disown
wmclockmon -lc lightblue -bl & disown
wmnd -I internal & disown
wmpulsemixer -w & disown
wmsystemtray & disown
wmaker

systemctl --user stop xdg-desktop-portal.service
systemctl --user stop windowmaker-session.target
