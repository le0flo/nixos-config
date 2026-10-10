import QtQuick
import Quickshell
import Quickshell.Hyprland

import "config.js" as Config

Scope {
    id: "root"

    required property int borderSize

    property int size: 56

    Variants {
        model: Quickshell.screens

        PanelWindow {
            anchors.left: true
            margins.left: dockHover.hovered ? 0 : -size + borderSize * 3

            implicitWidth: size

            color: "transparent"
            exclusiveZone: 0

            HoverHandler {
                id: "dockHover"
            }

            Rectangle {
                anchors {
                    fill: parent
                    leftMargin: -borderSize
                }

                color: Config.colors.background

                border {
                    width: borderSize
                    color: Config.colors.primary
                }

                Column {
                    id: "items"

                    anchors.centerIn: parent

                    spacing: 0

                    Repeater {
                        model: Hyprland.focusedWorkspace.toplevels.values.reduce((acc, t) => {
                            const existing = acc.find(item => item.id === t.wayland.appId)

                            if (existing) {
                                existing.instances.push(t)
                            }
                            else {
                                acc.push({
                                    id: t.wayland.appId,
                                    instances: [t]
                                })
                            }

                            return acc
                        }, [])

                        LeftDockItem {
                            size: root.size
                            borderSize: root.borderSize
                        }
                    }
                }
            }
        }
    }
}
