import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

PanelWindow {
    id: "bar"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30
    color: Config.colors.background

    Workspaces {}

    Clock {}
}
