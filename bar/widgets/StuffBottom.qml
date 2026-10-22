import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

RowLayout {
    id: root

    anchors.centerIn: parent

    property string ramValue: ""
    property string diskValue: ""

    Text {
        id: ramLabel
        font: normalFont
        color: theme.colors.accent
        textFormat: Text.RichText
        text: ramValue + " <font color=" + theme.colors.dark2 + ">RAM</font>"
    }

    Separator { text: "|"; color: theme.colors.dark2 }

    Text {
        id: diskLabel
        font: normalFont
        color: theme.colors.accent

        textFormat: Text.RichText
        text: diskValue + " <font color=" + theme.colors.dark2 + ">DISK</font>"
    }

    Process {
        id: ramProcess

        command: ["bash", "-c", "free -h --si | awk '/^Mem:/ {print $7}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: ramValue = text.trim()
        }
    }

    Process {
        id: diskProcess

        command: ["bash", "-c", "df -h | awk 'NR==2 {print $4}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: diskValue = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            ramProcess.running = true
            diskProcess.running = true
        }
    }
}