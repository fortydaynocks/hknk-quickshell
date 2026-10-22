import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

RowLayout {
    id: root

    Rectangle {
        implicitWidth: barSize * 0.5
        implicitHeight: barSize * 0.5

        color: theme.colors.accent

        Text {
            id: label
            anchors.centerIn: parent

            font: normalFont
            color: theme.colors.bg
            
            text: "󰤆"

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }
        }
    }
}