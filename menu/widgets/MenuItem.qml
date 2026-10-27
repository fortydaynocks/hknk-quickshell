import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property int long: 0
    property int tall: 0
    property var bg_color: theme.colors.dark1
    property var bg_opacity: 1

    property var outlineWidth: 0
    property var outlineOpacity: 1
    property var outlineColor: "#000000"

    Layout.preferredWidth: long
    Layout.preferredHeight: tall
    Layout.fillWidth: true

    color: "transparent"
    

    Rectangle {
        anchors.fill: parent

        color: root.bg_color
        opacity: root.bg_opacity
    }

    Rectangle {
        anchors.fill: parent

        border.width: outlineWidth
        border.color: outlineColor
        
        color: "transparent"
        opacity: outlineOpacity
    }
}