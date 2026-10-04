import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property string memValue: ""

    implicitWidth: label.width
    implicitHeight: barHeight
    
    color: "transparent"

    Text {
        id: label

        anchors.centerIn: parent

        font: normalFont

        color: color_bright3
        text: " "
    }

    //
    Process {
        id: memProcess

        command: ["bash", "-c", "nmcli | awk 'NR==1 {print $4}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: label.text = "󰖩 " + text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: memProcess.running = true
    }
}