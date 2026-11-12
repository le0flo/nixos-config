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

if [ "$wm" = "kwm" ]; then
    # TODO: stdin per la status bar
    exec kwm
else
    exec $wm
fi
