import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

Rectangle {
    id: root

    property string value: ""

    implicitWidth: diskLabel.width + 12
    implicitHeight: rightLayout.height

    color: theme.colorDark

    Text {
        id: diskLabel
        anchors.centerIn: parent

        font: normalFont
        color: theme.colorBright
        
        text: value
    }
}