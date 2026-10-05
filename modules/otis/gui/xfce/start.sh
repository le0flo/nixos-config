#!/usr/bin/env bash

export XDG_CURRENT_DESKTOP="xfce"
export XDG_SESSION_DESKTOP="xfce"
export XDG_SESSION_TYPE="x11"
export QT_QPA_PLATFORMTHEME="qt6ct"
export SSH_ASKPASS=""

exec startxfce4
