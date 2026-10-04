import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Networking

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: parent.width

    radius: parent.width / 4
    color: "transparent"

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: theme.colorBright
        
        text: "󰤨"
        z: 2
    }

    //PopupWindow {
        //id: popup
        //anchor.item: root

       // anchor.rect.x: barSize + padding
       // anchor.rect.y: -root.height
        
       // implicitWidth: 100
        //implicitHeight: 200

        //color: theme.colorBright
        
       // visible: true
   // }
}