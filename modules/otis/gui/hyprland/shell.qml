import QtQuick
import Quickshell

Scope {
    id: "root"

    property int borderSize: 2

    SystemClock {
        id: "clock"
        precision: SystemClock.Seconds
    }

    LeftDock { borderSize: root.borderSize }
    TopIsland { borderSize: root.borderSize }
}
