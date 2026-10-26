import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

ColumnLayout {
    id: root

    implicitWidth: parent.width
    spacing: padding

    Text { font: normalFont; color: theme.colors.dark3; text:"NOTIFICATIONS" }

    Rectangle {
        implicitWidth: root.width
        implicitHeight: 200

        border.width: strokeWidth
        border.color: theme.colors.stroke

        color: "transparent"
    }
}