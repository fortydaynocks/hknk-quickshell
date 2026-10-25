
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Hyprland

Item {
    id: root

    property string time: ""
    property string timeM: ""
    property string date: ""

    anchors.fill: parent

    RowLayout {
        id: layoutColumn
        anchors.centerIn: parent
        spacing: padding * 4

        Rectangle { implicitHeight: parent.height * 0.5; implicitWidth: strokeWidth; color: theme.colors.accent2; opacity: 0.25 }

        Text {
            id: labelH
            
            font.family: theme.font.family
            font.bold: true
            font.pointSize: 24

            color: theme.colors.accent2

            text: time
        }

        Rectangle { implicitHeight: parent.height * 0.5; implicitWidth: strokeWidth; color: theme.colors.accent }

        Text {
            Layout.alignment: Qt.AlignHCenter

            font.family: theme.font.family
            font.bold: true
            font.pointSize: 16

            color: theme.colors.accent

            text: date
        }

        Rectangle { implicitHeight: parent.height * 0.5; implicitWidth: strokeWidth; color: theme.colors.accent; opacity: 0.25 }

        
    }

    Process {
        id: timeProcess

        command: ["bash", "-c", "date '+%H:%M'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: time = text.trim()
        }
    }

    Process {
        id: dateProcess

        command: ["bash", "-c", "date '+%a %d %b'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: date = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timeProcess.running = true
        }
    }
}