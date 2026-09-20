import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes

import qs.components

import qs.bar.audio
import qs.bar.bluetooth
import qs.bar.clock
import qs.bar.hyprland
import qs.bar.tray


Scope {
    id: root

    property string clockText
    property int barHeight: 24
    property int extraWidth: 16

    //  OBJECTS
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            PanelWindow {
                id: panel
            
                //  MULTI-SCREEN
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                margins.top: 8
                implicitHeight: barHeight
                color: "transparent"

                //margins {
                   // top : 0
                   // left: 500
                    //right: 500
                    
                //}

                //Rectangle {
                    //anchors.centerIn: parent
                    
                   // width: 100
                    //height: barHeight

                    //color: "transparent"

                    //Shape {
                       // id: shape
                        //property int point_length: 20

                       // width: parent.width
                        //height: parent.height

                        //ShapePath {
                          // strokeWidth: 1
                           // fillColor: color_bright

                           // PathLine { x: shape.x + shape.width; y: 0 }
                           // PathLine { x: shape.x + shape.width + shape.point_length; y: shape.height / 2 }
                           // PathLine { x: shape.x + shape.width; y: shape.height}
                           // PathLine { x: shape.x; y: shape.height}
                           // PathLine { x: shape.x - shape.point_length; y: shape.height / 2 }
                           // PathLine { x: shape.x; y: 0 }
                            
                        //}
                   // }

                    //Clock {
                        //anchors.centerIn: parent
                        //color: color_bg
                    //}
                //}
                
                Rectangle {
                    id: background2

                    anchors.centerIn: parent

                    width: items_row.implicitWidth + extraWidth
                    height: barHeight

                    color: color_bg

                    BracketLeft {
                        anchors.verticalCenter: parent.verticalCenter

                        x: -14
                        y: 0

                        color: color_dark
                    }

                    BracketRight {
                        anchors.verticalCenter: parent.verticalCenter

                        x: background2.width + 6
                        y: 0

                        color: color_dark
                    }                
                }
                
                RowLayout {
                    id: items_row

                    anchors.centerIn: parent
                    spacing: 8
                    
                    //
                    BracketLeft {}

                    Media {}
                    Separator {}
                    Hypr {}
                    Separator {}
                    Clock {}
                    Separator {}
                    Bluetooth {}
                    Volume {}

                    BracketRight {}


                    //SystemTray {
                    //}
                }

                //Clock {
                    //anchors.centerIn: parent
                //}

                RowLayout {
                    anchors {right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 40
                    }
                    spacing: 30
                    
                    Separator { }
                }
            }
        }
    }
    // ----- these are outside the Variant so they are not made every time the bar is duplicated.
    
    // CLOCK PROCESSES
   
}
