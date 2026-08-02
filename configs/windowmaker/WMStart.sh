#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="windowmaker"
export XDG_SESSION_DESKTOP="windowmaker"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORMTHEME="qt6ct"

xrdb -merge ~/.config/X11/Xresources

systemctl --user import-environment \
  DISPLAY \
  XAUTHORITY \
  DBUS_SESSION_BUS_ADDRESS \
  XDG_SESSION_ID \
  XDG_CURRENT_DESKTOP \
  XDG_SESSION_DESKTOP \
  XDG_SESSION_TYPE

dbus-update-activation-environment --systemd --all

systemctl --user start nixos-fake-graphical-session.target

cputnik & disown
wmacpi & disown
wmclockmon & disown
wmnd -I home & disown
wmpulsemixer -w & disown
wmsystemtray & disown

wmaker
wmaker_status="$?"

systemctl --user stop nixos-fake-graphical-session.target

exit "$wmaker_status"
