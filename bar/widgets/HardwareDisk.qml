import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

RowLayout {
    id: root

    property string value: ""

    Text {
        id: diskLabel
        font: normalFont
        color: theme.colors.accent
        
        text: value
    }

    Text {
        font: normalFont
        color: theme.colors.dark1
        
        text: "DISK"
    }

    Process {
        id: process

        command: ["bash", "-c", "df -h | awk 'NR==2 {print $4}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: value = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            process.running = true
        }
    }
}