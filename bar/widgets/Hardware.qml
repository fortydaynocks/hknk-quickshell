import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import qs.bar.components
import qs.bar.widgets

Rectangle {
    id: root

    property string ramValue: ""
    property string diskValue: ""

    implicitWidth: layout.width
    implicitHeight: parent.height

    color: "transparent"

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: padding

        Spacer { Layout.alignment: Qt.AlignHCenter; text: "::"}
        HardwarePart {value: diskValue}
        HardwarePart {value: ramValue}
    }

   


    //  ==========================================================================================>

    Process {
        id: memProcess

        command: ["bash", "-c", "free -h --si | awk '/^Mem:/ {print $7}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: ramValue = " " + text
        }
    }

    Process {
        id: diskProcess

        command: ["bash", "-c", "df -h | awk 'NR==2 {print $4}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: diskValue = " " + text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            memProcess.running = true
            diskProcess.running = true
        }
    }
}