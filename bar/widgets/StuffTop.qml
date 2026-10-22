import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Hyprland

RowLayout {
    id: root
    anchors.centerIn: parent

    property var topLevel: Hyprland.activeToplevel
    property var topLevelName: Hyprland.activeToplevel.wayland.appId || ""

    Separator { id: sepLeft; text: "["; color: theme.colors.dark3 }

    Rectangle {
        id: nameRec

        implicitWidth: 0
        implicitHeight: parent.parent.height
        
        color: "transparent"
        clip: true

        Text {
            id: nameLabel
            anchors.centerIn: parent
            
            font: normalFont
            color: theme.colors.dark3

            text: topLevelName

            onTextChanged: { nameChangeAnim.restart() }
        }
    }

    Separator { id: sepRight; text: "]"; color: theme.colors.dark3 }

    SequentialAnimation {
        id: nameChangeAnim

        ParallelAnimation {
            ColorAnimation { target: sepLeft; property: "color"; to: theme.colors.accent; duration: 0 }
            ColorAnimation { target: sepRight; property: "color"; to: theme.colors.accent; duration: 0 }
            ColorAnimation { target: nameLabel; property: "color"; to: theme.colors.accent2; duration: 0 }
            NumberAnimation { target: nameRec; property: "implicitWidth"; to: 0; duration: 0 }

            ColorAnimation { target: sepLeft; property: "color"; to: theme.colors.dark3; duration: 300 }
            ColorAnimation { target: sepRight; property: "color"; to: theme.colors.dark3; duration: 300 }
            ColorAnimation { target: nameLabel; property: "color"; to: theme.colors.dark3; duration: 300; easing.type: Easing.OutCirc }
            NumberAnimation { target: nameRec; property: "implicitWidth"; to: nameLabel.width; duration: 300; easing.type: Easing.OutCirc }
        }

        ParallelAnimation {
            ColorAnimation { target: sepLeft; property: "color"; to: "transparent"; duration: 300 }
            ColorAnimation { target: sepRight; property: "color"; to: "transparent"; duration: 300 }
        }
    }

    
}