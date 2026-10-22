import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root
    

    implicitWidth: parent.width - (padding * 2)
    implicitHeight: parent.width - (padding * 2)

    color: theme.colors.stroke
    
    Text {
        anchors.centerIn: parent

        font.family: theme.font.family
        font.bold: theme.font.bold
        font.pixelSize: barSize * 0.5

        color: theme.colors.bg

        text: "󰋘"
    }
}
