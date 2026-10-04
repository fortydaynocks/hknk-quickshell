import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.SystemTray

import qs.components

RowLayout {
    id: layout

    spacing: 8
    Repeater {
        model: SystemTray.items

        Image {
            id: icon
            
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter

            source: modelData.icon
            sourceSize.width: barHeight * 0.8 //* 0.75
            sourceSize.height: barHeight * 0.8 //* 0.75

            PopupWindow {
                id: itemWindow

                implicitWidth: icon.sourceSize.width
                implicitHeight: icon.sourceSize.height
                anchor.item: icon

                mask: Region {}

                color: "transparent"
                visible: true

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                
                onClicked: function(mouse) {
                    if (mouse.button == Qt.LeftButton) {
                        modelData.activate()
                    }

                    else if (mouse.button == Qt.RightButton) {
                        if (modelData.hasMenu) {
                            modelData.display(itemWindow, 20, 20)

                        }
                    }
                }

                onEntered: {
                    icon.opacity = 0.5

                    //icon.sourceSize.width = barHeight * 1
                    //icon.sourceSize.height = barHeight * 1
                }
                
                onExited: {
                    icon.opacity = 1

                    //icon.sourceSize.width = barHeight * 0.75
                    //icon.sourceSize.height = barHeight * 0.75
                } 
            }
        }
    }

    
}