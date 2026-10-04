import Quickshell
import QtQuick

import "config.js" as Config

Rectangle {
    id: "island"

    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height
    color: Config.colors.background

    Text {
        id: "clock"

        property string currentTime: ""

        anchors.centerIn: parent

        text: "Orario (UTC+2): " + clock.currentTime
        color: Config.colors.text
        font.bold: true

        Timer {
            interval: 500
            running: true
            repeat: true

            onTriggered: {
                clock.currentTime = Qt.formatTime(new Date(), "HH:mm:ss")
            }
        }

        Component.onCompleted: {
            clock.currentTime = Qt.formatTime(new Date(), "HH:mm:ss")
        }
    }
}
