import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    required property int size
    required property int borderSize
    required property var modelData

    property bool hover: false
    property int size34: size * 3/4
    property int size35: size * 3/5
    property int borderSize3: borderSize * 3
    property int borderSize32: borderSize * 3/2

    width: size
    height: size

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true

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

        onEntered: { hover = true }
        onExited: { hover = false }

        IconImage {
            anchors {
                right: parent.right
                rightMargin: borderSize3
                verticalCenter: parent.verticalCenter
            }

            width: size35
            height: size35

            source: Quickshell.iconPath(DesktopEntries.byId(modelData.id).icon)
        }

        Column {
            anchors {
                left: parent.left
                leftMargin: borderSize3
                verticalCenter: parent.verticalCenter
            }

            spacing: borderSize

            Repeater {
                model: modelData.instances

                Rectangle {
                    width: borderSize3
                    height: borderSize3

                    color: "#FFFFFF"
                    radius: borderSize32
                }
            }
        }
    }
}
