#!/bin/sh

wm=$1

if [ -z $wm ]; then
    echo "Specifica un window manager da avviare"
    exit 1
fi

export XDG_CURRENT_DESKTOP="river"
export XDG_SESSION_TYPE="wayland"

systemctl --user import-environment \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP

dbus-update-activation-environment --systemd --all

systemctl --user start river-session.target
systemctl --user start xdg-desktop-portal.service

wlr-randr --output eDP-1 --mode 1920x1080@60
wlr-randr --output HDMI-A-3 --mode 1920x1080@75

if [ "$wm" = "kwm" ]; then
    exec statusblocks | kwm
else
    exec $wm
fi
