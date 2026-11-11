#!/bin/sh

systemctl --user import-environment \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP

dbus-update-activation-environment --systemd --all

systemctl --user start river-session.target
systemctl --user restart xdg-desktop-portal.service
