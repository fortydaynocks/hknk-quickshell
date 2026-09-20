import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.SystemTray

RowLayout {
    spacing: 10

    Repeater {
        model: SystemTray.items

        Image {
            
            //font: normalFont
            
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter

            //color: color_bright
            source: modelData.icon
            sourceSize.width: barHeight * 0.8
            sourceSize.height: barHeight * 0.8

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    parent.opacity = 0.5

                    parent.sourceSize.width = barHeight * 1
                    parent.sourceSize.height = barHeight * 1
                }
                
                onExited: {
                    parent.opacity = 1

                    parent.sourceSize.width = barHeight * 0.8
                    parent.sourceSize.height = barHeight * 0.8
                }

                onClicked: {
                    modelData.display(parent, 0, 0)
                }
            }
        }
    }
}