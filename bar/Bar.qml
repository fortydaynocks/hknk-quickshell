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

import qs.popupItems

Scope {
    id: root

    property string clockText
    property int barHeight: 24
    property int popupBarHeight: 48
    property int extraWidth: 16
    
    property real popupItemScale: 0.8
    property var dropped_down: false

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

                //clip: false

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

                    y: 0

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

                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    
                    BracketLeft {}

                    //  :::::   DROPDOWN    ::::: //

                    Rectangle {
                        id: dropdown

                        implicitWidth: items_row.height
                        implicitHeight: items_row.height 

                        color: dropped_down ? color_dark2 : color_bright

                        Text {
                            anchors.fill: parent

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            font: normalFont
                            color: dropped_down ? color_bright : color_bg

                            text: dropped_down ? "" : ""

                            Behavior on color {
                                ColorAnimation {
                                    easing.type: Easing.OutCirc
                                    duration: 200
                                }
                            } 
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: dropped_down = !dropped_down

                            onEntered: {
                                dropdown.opacity = 0.5

                            }

                            onExited: {
                                dropdown.opacity = 1

                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                easing.type: Easing.OutCirc
                                duration: 200
                            }
                        } 
                    }

                    //  :::::   FIRST LEVEL WIDGETS :::::   //

                    Media { id: media }
                    Separator {}
                    Hypr {}
                    Separator {}
                    Clock {}
                    Separator {}
                    Bluetooth {}
                    Volume {}
                    Separator {}
                    SystemTray {}

                    BracketRight {}
                }

                PopupWindow {
                    id: popup
                    anchor.window: panel

                    property int pad: 32

                    anchor.rect.x: items_row.x + (pad / 2)
                    anchor.rect.y: items_row.y + items_row.height + 6

                    implicitWidth: items_row.width - pad
                    implicitHeight: dropped_down ? items_row.height * 2 : 1

                    visible: dropped_down

                    color: "transparent"

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        implicitWidth: parent.width
                        implicitHeight: parent.height / 2

                        color: color_dark2

                        Text {
                            id: signature
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left

                            font: normalFont
                            color: color_dark

                            text: " :: HKNK"
                        }
                    
                        RowLayout {
                            id: popupRow

                            anchors.centerIn: parent
                            spacing: 4
                            
                            //  :::::   SECOND LEVEL WIDGETS    :::::   //

                            BracketLeft {color: color_dark3 }
                            Spacer {}

                            
                            Settings {}
                            Terminal {}
                            Folder {}
                            Screenshot {}
                            OBS {}
                            Discord {}
                            Steam {}

                            Spacer {}
                            BracketRight {color: color_dark3 }
                        }
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter

                        y: parent.height / 2
                        implicitWidth: parent.width
                        implicitHeight: parent.height / 2

                        color: color_dark
                    
                        RowLayout {
                            id: popupRow2

                            anchors.centerIn: parent
                            spacing: 4
                            
                            //  :::::   THIRD LEVEL WIDGETS    :::::   //

                            BracketLeft { color: color_dark2 }
                            Spacer {}
                            
                            RAM {}
                            Spacer {} Separator { color: color_dark2 } Spacer {}
                            Disk {}
                            Spacer {} Separator { color: color_dark2 } Spacer {}
                            WiFi {}
                            
                            Spacer {}
                            BracketRight { color: color_dark2 }
                        }
                    }

                    Behavior on implicitHeight {
                        NumberAnimation {
                            easing.type: Easing.OutCirc
                            duration: 200
                        }
                    }
                }
            }
        }
    }
    // ----- these are outside the Variant so they are not made every time the bar is duplicated.
    
    // CLOCK PROCESSES
   
}
