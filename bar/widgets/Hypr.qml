import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Widgets
import QtQuick.Layouts

import Quickshell.Hyprland

ColumnLayout {
    id: root
    spacing: padding * 2

    property var activeColor: theme.colors.accent

    Layout.alignment: Qt.AlignHCenter

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

        Rectangle {
            id: rec

            property var id: Hyprland.focusedWorkspace.name[modelData]
            property var workspaceData: Hyprland.workspaces.values.find(w => w.id == modelData)
            property bool isThisWindow: Hyprland.focusedWorkspace.name ? modelData == Hyprland.focusedWorkspace.name : false

            implicitWidth: barSize * 0.15
            implicitHeight: barSize * 0.15

            rotation: 45

            color: isThisWindow ? activeColor : (workspaceData ? theme.colors.dark3 : theme.colors.dark1)
        }
    }

    SequentialAnimation {
        id: animColor
        loops: Animation.Infinite
        running: true

        ColorAnimation {
            target: root
            property: "activeColor"

            from: theme.colors.accent
            to: theme.colors.accent2

            duration: 600
        }
        ColorAnimation {
            target: root
            property: "activeColor"

            from: theme.colors.accent2
            to: theme.colors.accent

            duration: 600
        }
    }
}