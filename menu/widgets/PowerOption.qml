import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    id: root
    
    property string title: "???"
    property string process: ""

    anchors.fill: parent

    border.width: strokeWidth
    border.color: theme.colors.dark2
    color: theme.colors.dark1

    Text {
        id: label

        anchors.centerIn: parent
        
        font: normalFont
        color: theme.colors.dark3

        text: title
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button == Qt.LeftButton && menuRoot.safetyLock == true) {
                menuRoot.safetyLock = false
                commandProcess.running = true
            }
        }

        onEntered: {
            root.color = theme.colors.accent
            root.border.color = theme.colors.accent
            label.color = theme.colors.accent2
        }

        onExited: {
            root.color = theme.colors.dark1
            root.border.color = theme.colors.dark2
            label.color = theme.colors.dark3
        }
    }

    Process {
        id: commandProcess

        command: ["bash", "-c", process]
    }
}