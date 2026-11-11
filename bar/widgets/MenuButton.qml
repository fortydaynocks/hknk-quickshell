import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    property bool hovering: false

    implicitWidth: parent.width - (padding * 2)
    implicitHeight: parent.width - (padding * 2)

    color: root.hovering ? theme.colors.dark3 : theme.colors.bg
    
    Text {
        id: label
        anchors.centerIn: parent

        font.family: theme.font.family
        font.bold: theme.font.bold
        font.pixelSize: barSize * 0.45

        color: root.hovering ? theme.colors.accent2 : theme.colors.dark3

        text: theme.menuIcon || "?"
    }

    MouseArea {
        id: volumeScroll
        anchors.fill: parent

        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button == Qt.LeftButton) {
                panel.toggleMenu(!panel.menuShowing)

            }
        }

        onEntered: {
            root.hovering = true

        }

        onExited: {
            root.hovering = false

        }
    }
}
