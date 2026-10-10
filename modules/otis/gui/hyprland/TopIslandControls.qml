import QtQuick
import Quickshell

import "config.js" as Config

Rectangle {
    required property int size
    required property int borderSize

    property bool active: false
    property int sizeM: (size - borderSize) / 10
    property int sizeT: (size - borderSize) / 6

    visible: active

    anchors {
        top: parent.top
        topMargin: -borderSize
    }

    width: parent.width
    height: size

    color: Config.colors.background

    border {
        width: borderSize
        color: Config.colors.primary
    }

    Column {
        anchors {
            right: parent.right
            rightMargin: sizeM
            verticalCenter: parent.verticalCenter
        }

        Text {
            text: Qt.formatDateTime(clock.date, "HH\nmm")

            color: Config.colors.primary

            font {
                bold: true
                pointSize: sizeT
            }
        }

        Text {
            text: Qt.formatDateTime(clock.date, "ss")

            color: Config.colors.secondary

            font {
                bold: true
                pointSize: sizeT
            }
        }
    }
}
