import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    implicitWidth: clock.width + 20
    implicitHeight: barHeight

    color: color_bright

    Rectangle {
        implicitWidth: parent.width * (1 - (Qt.formatDateTime(systemClock.date, "ss") / 60))
        implicitHeight: parent.height

        color: color_bright2

        Behavior on width {
            NumberAnimation {
                easing.type: Easing.OutCirc
                duration: 600
            }
        }
    }

    Text {
        id: clock
       
        property string time
        time: ClockTimer.time

        anchors.centerIn: parent
        

        font: normalFont
        color: color_bg
        
        text: "󱑂 " + Qt.formatDateTime(systemClock.date, "hh:mm AP")

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                clock.text = Qt.formatDateTime(systemClock.date, " dddd d MMMM yyyy")

            }

            onExited: {
                clock.text = "󱑂 " + Qt.formatDateTime(systemClock.date, "hh:mm AP")

            }
        }
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
        
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }
}
