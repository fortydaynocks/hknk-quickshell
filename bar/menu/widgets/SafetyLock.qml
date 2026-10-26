import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Widgets

Item {
    id: root

    anchors.fill: parent
    
    Text {
        anchors.fill: parent

        font: normalFont
        color: menuRoot.safetyLock ? theme.colors.accent : theme.colors.dark3

        text: ":: SAFETY LOCK"
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: parent.height * 0.75
        implicitWidth: 40

        color: menuRoot.safetyLock ? theme.colors.accent : theme.colors.dark2

        Item {
            anchors.fill: parent
            anchors.margins: 4

            Rectangle {
                x: menuRoot.safetyLock ? parent.width / 2 : 0

                implicitHeight: parent.height
                implicitWidth: parent.width / 2

                color: menuRoot.safetyLock ? theme.colors.accent2 : theme.colors.dark3
            }

        }

    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        onClicked: function(mouse) { if (mouse.button == Qt.LeftButton) { menuRoot.safetyLock = !menuRoot.safetyLock } }

        onEntered: { root.opacity = 0.5 }

        onExited: { root.opacity = 1 }
    }

    Connections {
        target: menuRoot

        function onVisibleChanged() {
            menuRoot.safetyLock = false
        }
    }
}