#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="windowmaker"
export XDG_SESSION_DESKTOP="windowmaker"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORMTHEME="qt6ct"

xrdb -merge ~/.config/X11/Xresources

cputnik & disown
wmacpi & disown
wmclockmon -lc lightblue -bl & disown
wmnd -I internal & disown
wmpulsemixer -w & disown
wmsystemtray & disown

xscreensaver --no-splash & disown

exec dbus-run-session wmaker
