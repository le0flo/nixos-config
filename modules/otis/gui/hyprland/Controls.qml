import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "config.js" as Config

Item {
    id: "controls"

    anchors {
        right: parent.right
        rightMargin: 5
    }

    width: controlsRow.implicitWidth
    height: parent.height

    RowLayout {
        id: "controlsRow"

        anchors.fill: parent
        spacing: 10

        Item {
            id: "tray"

            width: trayRow.implicitWidth
            height: parent.height

            RowLayout {
                id: "trayRow"

                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: SystemTray.items

                    Rectangle {
                        width: controls.height
                        height: controls.height

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
        }

        Text {
            id: "clock"

            property string currentTime: ""
            property int currentOffset: new Date().getTimezoneOffset() / -60

            text: "(UTC+" + clock.currentOffset + "): " + clock.currentTime
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

        IconImage {
            id: "lock"

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
