import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: label.height

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: theme.colorBright
        
        text: "⏻"
    }
}