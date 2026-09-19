export QML2_IMPORT_PATH="*qmlPath*:$QML2_IMPORT_PATH"

export QT_ENABLE_GLYPH_CACHE_WORKAROUND=1
export QT_FILE_SELECTORS=mediacenter
export QT_QPA_PLATFORM=wayland
export QT_QUICK_CONTROLS_MOBILE=true
export QT_QUICK_CONTROLS_STYLE=org.kde.breeze

export PLASMA_INTEGRATION_USE_PORTAL=1
export PLASMA_PLATFORM=mediacenter
export PLASMA_DEFAULT_SHELL=org.kde.plasma.bigscreen

export XCURSOR_THEME=breeze_cursors

export XDG_CONFIG_DIRS="$HOME/.config/plasma-bigscreen:/etc/xdg:$XDG_CONFIG_DIRS"
export XDG_DATA_DIRS="*kdePath*:$XDG_DATA_DIRS"

QT_QPA_PLATFORM=offscreen \
  *plasma-bigscreen*/bin/plasma-bigscreen-envmanager \
  --apply-settings

exec *dbus*/bin/dbus-run-session sh -c '
  *kactivitymanagerd*/libexec/kactivitymanagerd start-daemon &
  exec *wrapperDir*/kwin_wayland \
    "*plasma-workspace*/bin/plasmashell -p org.kde.plasma.bigscreen"
'
