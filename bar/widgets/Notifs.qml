import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: parent.width

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: theme.colors.accent2
        
        text: ""
    }
}