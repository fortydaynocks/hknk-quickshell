
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets

import qs.bar.components
import qs.bar.widgets

Scope {
    id: root

    //property string clockText
    //property int barHeight: 24
    //property int popupBarHeight: 48
    //property int extraWidth: 16
    
    //property real popupItemScale: 0.8
    //property var dropped_down: false

    property int barSize: 40
    property int padding: 8

    //  OBJECTS
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            Scope {
                required property var modelData

                PanelWindow {   //  <=====  TOP BAR
                    id: topPanel
                    screen: modelData
                    
                    anchors {
                        top: true
                        left: true
                        right: true
                    }
                    
                    implicitHeight: barSize
                    color: theme.colorBG
                    
                    WrapperItem {
                        anchors.left: parent.left
                        implicitHeight: parent.height
                        margin: padding

                        RowLayout {
                            id: topLayout

                            anchors.centerIn: parent
                            spacing: padding
                            
                            Cornerstone {}
                            Hypr {}
                            
                        }
                    }

                    WrapperItem {
                        anchors.centerIn: parent
                        implicitHeight: parent.height
                        margin: padding

                        RowLayout {
                            id: centerLayout

                            anchors.centerIn: parent
                            spacing: padding
                            
                            Media {}
                            Volume {}
                            
                        }
                    }

                    WrapperItem {
                        anchors.right: parent.right
                        implicitHeight: parent.height
                        margin: padding

                        RowLayout {
                            id: rightLayout

                            anchors.centerIn: parent
                            spacing: padding
                            
                            Tagline {}
                            Hardware {}
                            
                        }
                    }
                }

                PanelWindow {   //  <=====  TOP BAR
                    id: sidePanel
                    screen: modelData
                    
                    anchors {
                        top: true
                        bottom: true
                        left: true
                        
                    }
                    
                    implicitWidth: barSize
                    color: theme.colorBG
                   
                    WrapperItem {
                        anchors.bottom: parent.bottom
                        implicitWidth: parent.width
                        margin: padding

                        ColumnLayout {
                            id: sideLayout

                            anchors.centerIn: parent
                            spacing: padding

                            //WiFi {}
                            //WiFi {}
                            WiFi {}
                            Spacer { Layout.alignment: Qt.AlignHCenter; text: "["; rotation: 90 }
                            Clock {}
                            Spacer { Layout.alignment: Qt.AlignHCenter; text: "]"; rotation: 90 }
                            Power {}
                            
                        }
                    }
                }
            }
        }
    }
}