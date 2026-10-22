import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property string labelTextH: ""
    property string labelTextM: ""

    implicitWidth: parent.width
    implicitHeight: label.implicitHeight + 0

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        font: bigFont
        color: theme.colors.accent2
        
        textFormat: Text.RichText
        text:  labelTextH + "<br><font color=" + theme.colors.dark3 + ">" + labelTextM + "</font>"
    }

    Process {
        id: timeProcessH

        command: ["bash", "-c", "date '+%H'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: labelTextH = text.trim()
        }
    }

     Process {
        id: timeProcessM

        command: ["bash", "-c", "date '+%M'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: labelTextM = text.trim()
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
