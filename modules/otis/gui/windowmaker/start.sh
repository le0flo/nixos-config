#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="windowmaker"
export XDG_SESSION_DESKTOP="windowmaker"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORMTHEME="qt6ct"
export SSH_ASKPASS=""

xrdb -merge ~/.config/X11/Xresources

cputnik & disown
wmacpi & disown
wmclockmon & disown
wmnd -I home & disown
wmpulsemixer -w & disown
wmsystemtray & disown

exec wmaker
