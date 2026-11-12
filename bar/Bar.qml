
import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets

import qs.bar.widgets
import qs.menu

Scope {
    id: barRoot

    property int barSize: 42
    property int borderSize: 20

    property int padding: 4
    property int strokeWidth: 2

    property bool menuOpen: false

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Scope {
                required property var modelData

                PanelWindow { id: gapTop; screen: modelData; anchors.top: true; anchors.left: true; anchors.right: true; implicitHeight: borderSize; color: theme.colors.bg
                    Rectangle { anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; implicitWidth: (parent.width - (borderSize * 2)) + strokeWidth; implicitHeight: strokeWidth; color: theme.colors.stroke }
                
                    StuffTop {}
                }
                PanelWindow { id: gapBottom; screen: modelData; anchors.bottom: true; anchors.left: true; anchors.right: true; implicitHeight: borderSize; color: theme.colors.bg
                    Rectangle { anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter; implicitWidth: (parent.width - (borderSize * 2)) + strokeWidth; implicitHeight: strokeWidth; color: theme.colors.stroke }
                
                    StuffBottom {}
                }
                PanelWindow { id: gapLeft; screen: modelData; anchors.top: true; anchors.bottom: true; anchors.left: true; implicitWidth: borderSize; color: theme.colors.bg
                    exclusiveZone: barSize + borderSize
                    Rectangle { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; implicitWidth: strokeWidth; implicitHeight: parent.height; color: theme.colors.stroke }
                    //Component.onCompleted: panel.visible = true //  HAS TO LOAD FIRST
                }
                PanelWindow { id: gapRight; screen: modelData; anchors.top: true; anchors.bottom: true; anchors.right: true; implicitWidth: borderSize; color: theme.colors.bg
                    Rectangle { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; implicitWidth: strokeWidth; implicitHeight: parent.height; color: theme.colors.stroke }
                }

                PanelWindow {
                    id: panel
                    screen: modelData

                    property bool menuShowing: false

                    anchors.top: true
                    anchors.bottom: true
                    anchors.left: true

                    margins.left: -barSize
                    exclusiveZone: 0
                    implicitWidth: barSize

                    color: "transparent"
                    focusable: true

                    //visible: false
                    
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
                                    //Notifs {}
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

                    Menu {}
                }      
            }
        }
    }

    function toggleMenu(toggle = null) {
        if (toggle) {
            barRoot.menuOpen = toggle
        } else {
            barRoot.menuOpen = !barRoot.menuOpen
        }
    }

    //  COMMAND TO SHOW MENU    --  [  qs ipc call menu toggle ]
    IpcHandler {
        target: "bar"

        function toggle() {
            barRoot.toggleMenu()
            
        }
    }
}