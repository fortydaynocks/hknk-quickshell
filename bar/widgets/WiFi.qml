import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: barSize * 0.5
    implicitHeight: barSize * 0.5

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: theme.colors.accent2
        
        text: "󰖩"
    }
}