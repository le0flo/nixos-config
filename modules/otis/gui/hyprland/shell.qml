import QtQuick
import Quickshell

import "config.js" as Config

PanelWindow {
    id: "bar"

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: 32
    color: Config.colors.background

    Workspaces {}
    Controls {}
}
