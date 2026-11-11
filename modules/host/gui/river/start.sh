#!/usr/bin/env bash

export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=river

wm=$1

if [ -z $wm ]; then
    echo "Specifica un window manager da avviare"
    exit 1
elif [ "$wm" = "kwm" ]; then
    # TODO: stdin per la status bar
    exec river -c kwm
else
    exec river -c $wm
fi
