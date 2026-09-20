import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: rec

    implicitWidth: clock.width + 20
    implicitHeight: barHeight

    color: color_bright

    Rectangle {
        implicitWidth: parent.width * (1 - (ClockTimer.second / 60))
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
        
        text: "󱑂 " + ClockTimer.time
    }
}
