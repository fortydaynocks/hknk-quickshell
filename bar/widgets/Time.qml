import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: label.implicitHeight + 0

    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        font: bigFont
        color: theme.colors.accent2
        
        textFormat: Text.RichText
        text:  shellRoot.timeH + "<br><font color=" + theme.colors.dark3 + ">" + shellRoot.timeM + "</font>"
    }
}
