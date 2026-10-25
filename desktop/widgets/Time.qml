
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Hyprland

Item {
    id: root

    property string timeH: ""
    property string timeM: ""
    property string date: ""

    implicitWidth: layoutColumn.width
    implicitHeight: layoutColumn.height

    anchors.right: parent.right
    anchors.top: parent.top

    ColumnLayout {
        id: layoutColumn
        spacing: -20

        RowLayout {
            id: layoutRow
            spacing: padding

            Text {
                id: labelH
                
                font.family: theme.font.family
                font.bold: true
                font.pointSize: 64

                color: theme.colors.accent

                text: timeH
            }

            Text {
                id: labelM
                
                font.family: theme.font.family
                font.bold: true
                font.pointSize: 64

                color: theme.colors.accent
                opacity: 0.5

                text: ":" + timeM
            }
        }

        Text {
            Layout.alignment: Qt.AlignRight

            font.family: theme.font.family
            font.bold: true
            font.pointSize: 16

            color: theme.colors.accent
            opacity: 0.5

            text: date + " "
        }
    }

    Process {
        id: timeProcessH

        command: ["bash", "-c", "date '+%H'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeH = text.trim()
        }
    }

    Process {
        id: timeProcessM

        command: ["bash", "-c", "date '+%M'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeM = text.trim()
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
            timeProcessH.running = true
            timeProcessM.running = true
        }
    }
}