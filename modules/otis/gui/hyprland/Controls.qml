import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "config.js" as Config

Row {
    id: "controls"

    anchors.right: parent.right

    height: parent.height
    spacing: 10

    Row {
        id: "tray"

        height: parent.height
        spacing: 0

        Repeater {
            model: SystemTray.items

            Rectangle {
                width: parent.height
                height: parent.height

                color: Config.colors.background

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        modelData.activate()
                    }

                    Image {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        width: parent.height - 10
                        height: parent.height - 10
                        source: modelData.icon
                    }
                }
            }
        }
    }

    SystemClock {
        id: "clock"
        precision: SystemClock.Seconds
    }

    Rectangle {
        width: clockText.implicitWidth
        height: parent.height

        color: Config.colors.background

        Text {
            id: "clockText"

            anchors.centerIn: parent

            property int utcOffset: new Date().getTimezoneOffset() / -60

            text: "(UTC+" + utcOffset + "): " + Qt.formatTime(clock.date, "HH:mm:ss")
            color: Config.colors.text
            font.bold: true
        }
    }

    Rectangle {
        width: parent.height
        height: parent.height

        color: Config.colors.background

        IconImage {
            anchors.centerIn: parent

            width: parent.height - 10
            height: parent.height - 10

            source: Quickshell.iconPath("xfsm-lock")

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    Lock.lock.locked = true
                }
            }
        }
    }
}
