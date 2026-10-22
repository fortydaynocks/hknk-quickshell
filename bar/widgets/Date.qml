import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property string labelText: ""

    implicitWidth: label.width
    implicitHeight: label.implicitHeight + 0

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        font: normalFont
        color: theme.colors.accentdark
        
        text:  labelText

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.OutCirc
                duration: 200
            }
        }
    }

    Process {
        id: timeProcess

        command: ["bash", "-c", "date '+%a %d %b'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: labelText = text.trim()
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
