import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 0

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: rec

            property bool is_this_window: modelData.id == Hyprland.focusedWorkspace.name

            width: barHeight
            height: barHeight
            
            color: Hyprland.focusedWorkspace.urgent ? urgent_red : is_this_window ? color_bright : color_dark

            Text {
                anchors.centerIn: parent

                font.family: "JetBrainsMono Nerd Fonts Propo"
                font.bold: true
                font.pointSize: 10

                color: Hyprland.focusedWorkspace.urgent ? urgent_red : is_this_window ? color_dark : color_dark2
                text: modelData.id

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.OutCirc
                        duration: 600
                    }
                }
            }

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCirc
                    duration: 600
                }
            }
        }   
    }
}