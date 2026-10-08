import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "config.js" as Config

Item {
    id: "workspaces"

    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
    }

    width: workspacesRow.implicitWidth
    height: parent.height

    RowLayout {
        id: "workspacesRow"

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
}
