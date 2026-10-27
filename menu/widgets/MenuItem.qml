import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property var label: ""
    property var isButton: false

    property int long: 0
    property int tall: 0
    property var bg_color: theme.colors.dark1
    property var bg_opacity: 1

    property var outlineWidth: 0
    property var outlineOpacity: 1
    property var outlineColor: "#000000"
    
    property var buttonFunction: function(mouse) {}

    Layout.preferredWidth: long
    Layout.preferredHeight: tall
    Layout.fillWidth: true

    color: "transparent"
    

    Rectangle {
        id: bg
        anchors.fill: parent

        color: root.bg_color
        opacity: root.bg_opacity
    }

    Rectangle {
        id: border
        anchors.fill: parent

        border.width: outlineWidth
        border.color: outlineColor
        
        color: "transparent"
        opacity: outlineOpacity
    }

    Text {
        id: labelText

        anchors.centerIn: parent
        
        font: normalFont
        color: theme.colors.dark3

        text: label
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true

        enabled: isButton

        onClicked: function(mouse) {buttonFunction(mouse)}

        onEntered: {
            bg_color = theme.colors.accent
            outlineColor = theme.colors.accent
            labelText.color = theme.colors.bg
        }

        onExited: {
            bg_color = theme.colors.dark1
            outlineColor = theme.colors.stroke
            labelText.color = theme.colors.dark3
        }
    }
}