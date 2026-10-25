import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: parent.width

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: theme.colors.accent2
        
        text: ""
    }

    Process {
        id: notifProcess
        command: ["bash", "-c", "swaync-client -t -sw"]
    }

    MouseArea {
        id: volumeScroll
        anchors.fill: parent

        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button == Qt.LeftButton) {
                notifProcess.running = true
            }
        }

        onEntered: {
            root.opacity = 0.5

        }

        onExited: {
            root.opacity = 1

        }
    }
}