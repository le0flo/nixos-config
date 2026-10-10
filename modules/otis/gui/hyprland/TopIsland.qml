import QtQuick
import Quickshell

Scope {
    id: "root"

    required property int borderSize

    property int workspacesSize: 24
    property int controlsSize: 150

    Variants {
        model: Quickshell.screens

        PanelWindow {
            anchors.top: true

            implicitWidth: 400
            implicitHeight: islandHover.hovered ? controlsSize : workspacesSize

            color: "transparent"
            exclusiveZone: workspacesSize

            HoverHandler {
                id: "islandHover"
            }

            TopIslandWorkspaces {
                size: root.workspacesSize
            }

            TopIslandControls {
                size: root.controlsSize
                borderSize: root.borderSize
                active: islandHover.hovered
            }
        }
    }
}
