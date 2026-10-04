import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 6

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9]

         Rectangle {
            id: rec

            required property int index
            required property string modelData

            property int workspace_id: index + 1
            property var workspace_data: Hyprland.workspaces.values.find(w => w.id == workspace_id)
            property bool is_this_window: workspace_id == Hyprland.focusedWorkspace.name

            implicitWidth: workspace_data ? topLayout.height : topLayout.height / 4
            implicitHeight: workspace_data ? topLayout.height / 4 : topLayout.height / 4
            
            color: workspace_data ? (is_this_window ? theme.colorBright : theme.colorDark2) : theme.colorDark

            //Text {
                //anchors.centerIn: parent

                //font: normalFont

                //color: Hyprland.focusedWorkspace.urgent ? theme.colorRed : is_this_window ? theme.colorDark : theme.colorDark2
                //text: modelData.id

                //Behavior on color {
                    //ColorAnimation {
                        //easing.type: Easing.OutCirc
                        //duration: 600
                    //}
                //}
            //}

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCirc
                    duration: 600
                }
            }

            Behavior on implicitWidth {
                NumberAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }

            Behavior on implicitHeight {
                NumberAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }
        }   
    }
}