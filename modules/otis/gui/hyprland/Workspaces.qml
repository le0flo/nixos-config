import Quickshell
import Quickshell.Hyprland
import QtQuick

import "config.js" as Config

Row {
    id: "workspaces"

    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
    }

    height: parent.height

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            width: workspaces.height
            height: workspaces.height

            color: modelData.active ? Config.colors.primary : Config.colors.background

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    modelData.activate()
                }

                Text {
                    anchors.centerIn: parent

                    text: modelData.id
                    color: modelData.active ? Config.colors.background : Config.colors.text
                    font.bold: true
                }
            }
        }
    }
}
