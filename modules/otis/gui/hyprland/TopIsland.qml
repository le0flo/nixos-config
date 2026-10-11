import QtQuick
import Quickshell
import Quickshell.Hyprland

import "config.js" as Config

Scope {
    id: "root"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 24

            color: "transparent"

            Rectangle {
                anchors {
                    top: parent.top
                    topMargin: parent.height / 4
                    horizontalCenter: parent.horizontalCenter
                }

                width: row.implicitWidth + parent.height * 3/4
                height: parent.height * 3/4

                color: "#A93A3A3A"
                radius: height

                Row {
                    id: "row"

                    anchors.centerIn: parent

                    height: parent.height

                    spacing: height / 3

                    Repeater {
                        model: Hyprland.workspaces

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter

                            width: modelData.active ? parent.height : parent.height / 3
                            height: parent.height / 3

                            radius: height

                            color: modelData.active ? Config.colors.text : Config.colors.background
                        }
                    }
                }
            }
        }
    }
}
