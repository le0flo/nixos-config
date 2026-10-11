import QtQuick
import Quickshell

Scope {
    id: "root"

    SystemClock {
        id: "clock"
        precision: SystemClock.Seconds
    }

    BottomDock {}
    TopIsland {}
}
