import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls

import qs.bar.menu.widgets

PopupWindow {
    id: menuRoot

    property string iAm: ""
    property bool safetyLock: false

    anchor.window: panel
    anchor.rect.x: barSize + padding
    anchor.rect.y: padding

    implicitWidth: 400
    implicitHeight: panel.height ? panel.height - (padding * 2) : 600

    visible: !panel.menuShowing
    //grabFocus: true
    //mask: Region { item: menuContainer }
    //mask: Region {}

    color: "transparent"

    Item {
        id: menuContainer
        implicitWidth: parent.width
        implicitHeight: parent.height

        Rectangle {
            anchors.fill: parent

            border.width: strokeWidth
            border.color: theme.colors.stroke

            color: theme.colors.bg
        }

        Item {
            id: menuFill

            anchors.fill: parent
            anchors.margins: padding * 2

            ColumnLayout {
                anchors.fill: parent
                spacing: padding * 2

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop

                    MenuItem { long: 1; tall: 20; bg_color: "transparent"
                        MyName {}

                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }

                    MenuItem { long: 1; tall: 40; bg_color: "transparent"
                        Time {}

                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: padding * 2
                        
                        visible: media != null

                        MenuItem { long: 5; tall: 40; bg_color: "transparent"
                            Media {}

                        }

                        MenuItem { long: 1; tall: 40; bg_color: "transparent"
                            MediaCava {}

                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }
                }
                

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //Rectangle {
                        //implicitWidth: parent.width
                        //implicitHeight: 2000
                        
                        //opacity: 0.1
                    //}
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignBottom

                    Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: padding * 2

                        MenuItem { long: 1; tall: 20; bg_color: "transparent"
                            PowerOption {
                                title: "󰐥 POWER"
                                process: "systemctl poweroff"

                            }
                        }

                        MenuItem { long: 1; tall: 20; bg_color: theme.colors.dark1; outlineWidth: strokeWidth; outlineColor: theme.colors.dark2
                            PowerOption {
                                title: " RESTART"
                                process: "systemctl reboot"

                            }
                        }

                        MenuItem { long: 1; tall: 20; bg_color: theme.colors.dark1; outlineWidth: strokeWidth; outlineColor: theme.colors.dark2
                            PowerOption {
                                title: "󰤄 SLEEP"
                                process: "systemctl sleep"

                            }
                        }

                        MenuItem { long: 1; tall: 20; bg_color: theme.colors.dark1; outlineWidth: strokeWidth; outlineColor: theme.colors.dark2
                            PowerOption {
                                title: " WIP"
                                

                            }
                        }
                    }

                    MenuItem { long: 1; tall: 20; bg_color: "transparent"
                        SafetyLock {}
                    }
                }
            }
        }
        
        //Item {
        //    id: menuFill

        //    anchors.fill: parent
        //    anchors.margins: padding * 4

        //    ColumnLayout {
        //        anchors.top: parent
        //        implicitWidth: parent.width
        //        spacing: padding * 2

        //        MenuItem { long: 1; tall: 20; bg_color: "transparent"
        //            MyName {}

        //        }

        //        Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }

        //        RowLayout {
        //            spacing: padding * 2

        //            Rectangle { implicitWidth: strokeWidth; implicitHeight: parent.height * 0.75; color: theme.colors.accent }

        //            MenuItem { long: 1; tall: 80; bg_color: "transparent"
        //                Time {}

        //            }

        //            MenuItem { long: 2; tall: 80; bg_color: "transparent"
        //               Media {}

        //            }
        //        }

        //        Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }
                
        //        MenuItem { long: 1; tall: 430; bg_color: theme.colors.dark1; bg_opacity: 0.5
        //            Rectangle {
        //                anchors.fill: parent

        //                border.width: strokeWidth
        //                border.color: theme.colors.dark2

        //                color: "transparent"
        //            }

        //            Item {
        //                anchors.fill: parent
        //                anchors.margins: padding * 4

        //                ColumnLayout {
        //                    anchors.top: parent
        //                    implicitWidth: parent.width
        //                    spacing: padding * 2

        //                    OptionsTabs {}
        //                    Rectangle { Layout.fillWidth: true; implicitHeight: strokeWidth; color: theme.colors.dark2 }
        //                }
        //            }
        //        }

                //RowLayout {
                    //spacing: padding * 2

                    //MenuItem { long: 1; tall: 40; bg_color: theme.colors.dark1; opacity: 0.5

                    //}

                    //MenuItem { long: 1; tall: 40; bg_color: theme.colors.dark1; opacity: 0.5

                    //}
                //}

                //MenuItem { long: 1; tall: 120; bg_color: theme.colors.dark1; opacity: 0.5

                //}
                //MenuItem { row: 1; colm: 0; span: 12; pHeight: 40 }
                //MenuItem { row: 0; colm: 0; span: 2; long: 1; pHeight: 40 }
                //MenuItem { row: 2; colm: 0; span: 1; long: 1; pHeight: 40 }
                //MenuItem { row: 2; colm: 1; span: 1; long: 1; pHeight: 40 }
        //    }

            //ColumnLayout {
            //    anchors.fill: parent
            //    implicitWidth: parent.width
            //    spacing: padding * 2

            //    MyName { Layout.alignment: Qt.AlignLeft }
            //    Rectangle { implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.dark2; opacity: 0.5 }
            //    RowLayout {
            //        spacing: padding

            //        Time { Layout.alignment: Qt.AlignHCenter }
            //        Rectangle { implicitWidth: strokeWidth; implicitHeight: parent.height * 0.75; color: theme.colors.dark2; opacity: 0.5 }
            //        Media {}
            //    }
                
                
            //    Rectangle { implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.accent }
                
            //    Rectangle { implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.dark2; opacity: 0.5 }
                
            //    Notifs { Layout.alignment: Qt.AlignLeft }
                //ColumnLayout {
                //    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                //    implicitWidth: parent.width
                //    spacing: padding

                //    RowLayout {
                //        spacing: padding
                //        
                //        Notifs { Layout.alignment: Qt.AlignHCenter }
                //    }
                //}
                
            //    Rectangle { implicitWidth: parent.width; implicitHeight: strokeWidth; color: theme.colors.stroke; opacity: 0.5 }
                
            //}   

            
        //}

        Rectangle {
            id: blueOverlay

            anchors.right: parent.right
            implicitWidth: 0;
            implicitHeight: parent.height;

            color: theme.colors.accent
        }
    }

    SequentialAnimation {
        id: showMenu

        PropertyAction { target: menuContainer; property: "implicitWidth"; value: 0 }
        PropertyAction { target: menuFill; property: "opacity"; value: 0 }
        PropertyAction { target: blueOverlay; property: "implicitWidth"; value: menuRoot.width }
        
        NumberAnimation { target: menuContainer; property: "implicitWidth"; to: menuRoot.width; duration: 200; easing.type: Easing.InOutCirc }
        PropertyAction { target: menuFill; property: "opacity"; value: 1 }
        NumberAnimation { target: blueOverlay; property: "implicitWidth"; to: 0; duration: 200; easing.type: Easing.OutCirc }

        //ParallelAnimation { 
        //}

        //ParallelAnimation {
        //}
    }

    SequentialAnimation {
        id: hideMenu
        
    }
    
    onVisibleChanged: {
        if (menuRoot.visible == true) {
            showMenu.restart()

        } else {
            //blueOverlay.implicitWidth = menuRoot.width

        }
    }
}
