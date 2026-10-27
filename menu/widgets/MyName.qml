import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    anchors.fill: parent

    Text {
        id: label

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        font.family: theme.font.family
        font.bold: theme.font.bold
        font.pointSize: 12
        color: theme.colors.dark3

        textFormat: Text.RichText
        text: ":: WELCOME, <font color=" + theme.colors.accent + ">" + iAm + "</font>."

        Process {
            id: iAmProcess
            command: ["bash", "-c", "whoami"]
            running: true
            stdout: StdioCollector { onStreamFinished: menuRoot.iAm = text.trim().toUpperCase() }
        }
    }
}