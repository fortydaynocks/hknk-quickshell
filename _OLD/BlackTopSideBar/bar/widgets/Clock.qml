import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import qs.bar.components

Rectangle {
    id: root

    property bool hovering: false
    property string timeText: ""
    property string dateText: ""

    implicitWidth: parent.width
    implicitHeight: label.implicitHeight + 0

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        font: bigFont
        color: hovering ? theme.colorDark2 : theme.colorBright
        
        text:  hovering ? dateText : timeText

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.OutCirc
                duration: 200
            }
        }
    }

    MouseArea {
        id: volumeScroll
        anchors.fill: parent

        hoverEnabled: true

        onEntered: hovering = true
        onExited: hovering = false
    }

    Process {
        id: timeProcess

        command: ["bash", "-c", "date '+%H%n%M'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeText = text.trim()
        }
    }

    Process {
        id: dateProcess

        command: ["bash", "-c", "date '+%a%n%d%n%b'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: dateText = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timeProcess.running = true
            dateProcess.running = true
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }
}
