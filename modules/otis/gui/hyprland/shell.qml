import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

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

    Clock {}
}
