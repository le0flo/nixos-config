pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

import "config.js" as Config

Singleton {
    property alias lock: sessionLock

    WlSessionLock {
        id: "sessionLock"

        WlSessionLockSurface {
            color: Config.colors.background

            Rectangle {
                anchors.centerIn: parent

                width: 300
                height: 100

                color: Config.colors.primary

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        sessionLock.locked = false
                    }

                    Text {
                        anchors.centerIn: parent

                        text: "unlock me"
                        color: Config.colors.background
                    }
                }
            }
        }
    }
}
