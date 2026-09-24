import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    implicitWidth: clock.width + 20
    implicitHeight: barHeight

    color: color_bright

    property string timeText: ""
    property string dateText: ""
    property int secondText: 0

    Rectangle {
        implicitWidth: parent.width * (1 - (secondText / 60))
        implicitHeight: parent.height

        color: color_bright2

        Behavior on implicitWidth {
            NumberAnimation {
                easing.type: Easing.OutCirc
                duration: 600
            }
        }
    }

    Text {
        id: clock
        anchors.centerIn: parent

        font: normalFont
        color: color_bg
        
        text: "󱑂 " + timeText

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                clock.text = "󱑂 " + dateText

            }

            onExited: {
                clock.text = "󱑂 " + timeText

            }
        }
    }

    Process {
        id: timeProcess

        command: ["bash", "-c", "date '+%I:%M %^p'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeText = text
        }
    }

    Process {
        id: dateProcess

        command: ["bash", "-c", "date '+%A %d %B %Y'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: dateText = text
        }
    }

    Process {
        id: secondProcess

        command: ["bash", "-c", "date +%S"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: secondText = text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timeProcess.running = true
            dateProcess.running = true
            secondProcess.running = true
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }
}
