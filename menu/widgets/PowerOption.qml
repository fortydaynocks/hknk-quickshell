import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    id: root

    property bool hovering: false
    
    property string title: "???"
    property string process: ""

    anchors.fill: parent

    border.width: strokeWidth
    border.color: root.hovering ? theme.colors.accent : theme.colors.stroke
    color: root.hovering ? theme.colors.accent : theme.colors.bg

    Text {
        id: label

        anchors.centerIn: parent
        
        font: normalFont
        color: root.hovering ? theme.colors.accent2 : theme.colors.accent

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
            root.hovering = true
            
        }

        onExited: {
            root.hovering = false

        }
    }

    Process {
        id: commandProcess

        command: ["bash", "-c", process]
    }
}