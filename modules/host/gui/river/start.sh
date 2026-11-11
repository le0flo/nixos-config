#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="river"
export XDG_SESSION_TYPE="wayland"

init=~/.config/river/init
wm=$1

if [ -z $wm ]; then
    echo "Specifica un window manager da avviare"
    exit 1
elif [ "$wm" = "kwm" ]; then
    # TODO: stdin per la status bar
    exec river -c "$init; kwm"
else
    exec river -c "$init; $wm"
fi
