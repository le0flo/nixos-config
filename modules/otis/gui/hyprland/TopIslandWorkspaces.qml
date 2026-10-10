import QtQuick
import Quickshell
import Quickshell.Hyprland

import "config.js" as Config

Rectangle {
    required property int size

    property int size14: size * 1/4
    property int size34: size * 3/4

    anchors {
        top: parent.top
        topMargin: size14
        horizontalCenter: parent.horizontalCenter
    }

    width: row.implicitWidth + size34
    height: size34

    color: "#A93A3A3A"
    radius: size

    Row {
        id: "row"

        anchors.centerIn: parent

        spacing: size14

        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                width: modelData.active ? size34 : size14
                height: size14

                radius: size14

                color: modelData.active ? Config.colors.text : Config.colors.background
            }
        }
    }
}
