
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets

import qs.bar.widgets
import qs.menu

Scope {
    id: root

    property int barSize: 42
    property int borderSize: 20

    property int padding: 4
    property int strokeWidth: 2

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Scope {
                required property var modelData

                PanelWindow { id: gapLeft; screen: modelData; anchors.top: true; anchors.bottom: true; anchors.left: true; implicitWidth: borderSize; color: theme.colors.bg
                    Rectangle { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; implicitWidth: strokeWidth; implicitHeight: parent.height - ((borderSize * 2) - (strokeWidth * 2)); color: theme.colors.stroke }
                }
                PanelWindow { id: gapRight; screen: modelData; anchors.top: true; anchors.bottom: true; anchors.right: true; implicitWidth: borderSize; color: theme.colors.bg
                    Rectangle { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; implicitWidth: strokeWidth; implicitHeight: parent.height - ((borderSize * 2) - (strokeWidth * 2)); color: theme.colors.stroke }
                }
                PanelWindow { id: gapTop; screen: modelData; anchors.top: true; anchors.left: true; anchors.right: true; implicitHeight: borderSize; color: theme.colors.bg
                    Rectangle { anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.stroke }
                
                    StuffTop {}
                }
                PanelWindow { id: gapBottom; screen: modelData; anchors.bottom: true; anchors.left: true; anchors.right: true; implicitHeight: borderSize; color: theme.colors.bg
                    Rectangle { anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.stroke }
                
                    StuffBottom {}
                }

                PanelWindow {
                    id: panel
                    screen: modelData

                    property bool menuShowing: false

                    anchors.top: true
                    anchors.bottom: true
                    anchors.left: true

                    implicitWidth: barSize

                    color: "transparent"
                    
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        implicitWidth: parent.width - padding
                        implicitHeight: parent.height - (padding * 2)

                        border.width: strokeWidth
                        border.color: theme.colors.stroke

                        color: theme.colors.bg

                        Hypr { anchors.centerIn: parent }

                        WrapperItem {
                            anchors.fill: parent
                            margin: padding

                            ColumnLayout {
                                implicitWidth: parent.width
                                spacing: padding
                                
                                ColumnLayout {
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                    implicitWidth: parent.width
                                    spacing: padding
                                    
                                    Item {}
                                    MenuButton { Layout.alignment: Qt.AlignHCenter }
                                    Item {}
                                    Time {}
                                    Notifs {}
                                    Separator { text: ""; color: theme.colors.dark2; Layout.alignment: Qt.AlignHCenter }
                                }

                                ColumnLayout {
                                    //Layout.alignment: Qt.AlignCenter
                                    implicitWidth: parent.width
                                    spacing: padding

                                    
                                }

                                ColumnLayout {
                                    spacing: padding
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                                    Media {}

                                    //WiFi {}
                                    //Bluetooth {}
                                    Separator { text: ""; color: theme.colors.dark2; Layout.alignment: Qt.AlignHCenter }
                                    SystemTray {}
                                    //Separator { text: ""; color: theme.colors.dark2; Layout.alignment: Qt.AlignHCenter }
                                    //Power {}
                                    Item {}
                                }
                            }
                        }
                    }

                    Menu { id: menu }

                    function toggleMenu(toggle) {
                        menu.visible = toggle
                        
                    }
                }      
            }
        }
    }
}