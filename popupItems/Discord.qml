import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property var hovering: false

    implicitWidth: barHeight + text.width
    implicitHeight: barHeight
    
    color: color_dark3

    Text {
        id: text

        anchors.centerIn: parent

        font: normalFont

        color: color_bright
        text: hovering ? "  DISCORD" : ""
    }

    Process {
        id: action
        command: ["bash", "-c", "discord"]
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onClicked: action.running = true

        onEntered: {
            hovering = true
            root.opacity = 0.5

        }

        onExited: {
            hovering = false
            root.opacity = 1

        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }
}