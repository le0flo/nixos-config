import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    required property var modelData

    width: parent.height
    height: parent.height

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            switch (mouse.button) {
                case Qt.LeftButton:
                    if (modelData.instances.length > 0) {
                        const i = modelData.instances.pop()
                        i.wayland.activate()
                        modelData.instances.unshift(i)
                    }
                    else {
                        console.log("TODO: istanziare una app")
                    }
                    break
                case Qt.RightButton:
                    console.log("TODO: aprire un menu")
                    break
            }
        }

        IconImage {
            anchors {
                top: parent.top
                topMargin: 3
                horizontalCenter: parent.horizontalCenter
            }

            width: parent.height * 3/4
            height: parent.height * 3/4

            source: Quickshell.iconPath(DesktopEntries.byId(modelData.id).icon)
        }

        Row {
            anchors {
                bottom: parent.bottom
                bottomMargin: 3
                horizontalCenter: parent.horizontalCenter
            }

            spacing: 3

            Repeater {
                model: modelData.instances

                Rectangle {
                    width: 6
                    height: 6

                    color: "#E6E6E6"
                    radius: 6
                }
            }
        }
    }
}
