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
        color: theme.colors.dark2
        
        text: "RAM"
    }

    Process {
        id: process

        command: ["bash", "-c", "free -h --si | awk '/^Mem:/ {print $7}'"]
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