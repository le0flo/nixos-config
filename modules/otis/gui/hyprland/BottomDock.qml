import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "config.js" as Config

Scope {
    id: "root"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            anchors {
                bottom: true
                left: true
                right: true
            }

            margins {
                bottom: dockHover.hovered ? 0 : -height + 6
                left: 24
                right: 24
            }

            implicitHeight: 56

            color: "transparent"
            exclusiveZone: 0

            BackgroundEffect.blurRegion: Region { item: dock }

            HoverHandler {
                id: "dockHover"
            }

            Rectangle {
                id: "dock"

                anchors.horizontalCenter: parent.horizontalCenter

                width: Math.max(items.implicitWidth + 10, 100)
                height: parent.height

                color: "#CC363636"

                radius: 10

                border {
                    width: 1
                    color: "#26FFFFFF"
                }

                Row {
                    id: "items"

                    anchors.centerIn: parent

                    height: parent.height

                    spacing: 2

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

                        BottomDockItem {}
                    }
                }
            }
        }
    }
}
