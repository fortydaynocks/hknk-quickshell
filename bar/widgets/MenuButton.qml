import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    implicitWidth: parent.width - (padding * 2)
    implicitHeight: parent.width - (padding * 2)

    color: theme.colors.accent
    
    Text {
        id: label
        anchors.centerIn: parent

        font.family: theme.font.family
        font.bold: theme.font.bold
        font.pixelSize: barSize * 0.45

        color: theme.colors.accent2

        text: theme.menuIcon || "?"
    }

    MouseArea {
        id: volumeScroll
        anchors.fill: parent

        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button == Qt.LeftButton) {
                panel.toggleMenu(!panel.menuShowing)
                //Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
            }
        }

        onEntered: {
            root.color = theme.colors.accent2
            label.color = theme.colors.accent

        }

        onExited: {
            root.color = theme.colors.accent
            label.color = theme.colors.accent2

        }
    }
}
