
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Hyprland

Item {
    id: root

    implicitWidth: layoutColumn.width
    implicitHeight: layoutColumn.height

    anchors.right: parent.right
    anchors.top: parent.top

    ColumnLayout {
        id: layoutColumn
        spacing: -20

        RowLayout {
            id: layoutRow
            spacing: padding

            Text {
                id: labelH
                
                font.family: theme.font.family
                font.bold: true
                font.pointSize: 64

                color: theme.colors.accent2

                text: shellRoot.timeH
            }

            Text {
                id: labelM
                
                font.family: theme.font.family
                font.bold: true
                font.pointSize: 64

                color: theme.colors.accent2
                //opacity: 0.5

                text: ":" + shellRoot.timeM
            }
        }

        Text {
            Layout.alignment: Qt.AlignRight

            font.family: theme.font.family
            font.bold: true
            font.pointSize: 16

            color: theme.colors.accent2
            //opacity: 0.5

            text: shellRoot.date + " "
        }
    }
}