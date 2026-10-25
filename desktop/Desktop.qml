
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets

import qs.desktop.widgets

Scope {
    id: root

    property int padding: 4

    Variants {
        model: Quickshell.screens;

        delegate: Component {
            Scope {
                required property var modelData

                PanelWindow {
                    id: panel
                    
                    
                    screen: modelData

                    anchors.top: true
                    anchors.bottom: true
                    anchors.left: true
                    anchors.right: true

                    exclusiveZone: 0
                    aboveWindows: false

                    color: "transparent"

                    Item {
                        anchors.centerIn: parent

                        implicitWidth: parent.width - (padding * 2)
                        implicitHeight: parent.height - (padding * 2)
                

                        Time {}
                    }
                }
            }
        }
    }
}