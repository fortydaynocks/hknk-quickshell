import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel

import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Hyprland

PopupWindow {
    id: root

    anchor.window: panel

    anchor.rect.x: (Screen.width - implicitWidth) / 2
    anchor.rect.y: 0 //(Screen.height - implicitHeight) / 2

    implicitWidth: 1000
    implicitHeight: 400

    color: "transparent"

    visible: false
    //grabFocus: true
    //mask: Region {}

    Rectangle {
        anchors.fill: parent

        border.width: strokeWidth
        border.color: theme.colors.stroke

        color: theme.colors.bg
    }

    Item {
        anchors.fill: parent
        anchors.margins: padding * 4

        ColumnLayout {
            anchors.fill: parent
            spacing: padding * 2

            //implicitWidth: parent.width - (padding * 8)
            //implicitHeight: parent.height - (padding * 16)

            Text {

                color: theme.colors.accent
                font: bigFont

                text: ":: THEME SWITCHER"
            }

            ListView {
                id: listView

                Layout.fillHeight: true
                Layout.fillWidth: true

                orientation: Qt.LeftToRight
                spacing: padding * 2

                model: folderModel
                clip: true

                highlight: Rectangle {  implicitHeight: listView.height; implicitWidth: 100; color: theme.colors.accent }

                FolderListModel {
                    id: folderModel
                    folder: shellRoot.themesPath
                    nameFilters: ["*.json"]

                }

                delegate: Item {
                    required property string fileName
                    required property string fileUrl
                    readonly property var themeData: JSON.parse(newThemeJson.text())


                    property var selecting: false
                    //font: normalFont
                    //color: theme.colors.accent2

                    //text: fileName + "..."

                    implicitHeight: listView.height //  DON'T USE "parent", IT CAN SOMETIMES BE NULL.
                    implicitWidth: 100

                    //opacity: selecting ? 1 : 0.5

                    FileView {
                        id: newThemeJson
                        path: fileUrl

                        blockLoading: true
                        watchChanges: true

                        onFileChanged: this.reload()
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: padding * 2

                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true

                            font: normalFont
                            color: themeData.colors.accent2
                            elide: Text.ElideRight

                            text: themeData.name.toUpperCase()
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            color: themeData.colors.bg
                            clip: true

                            Image {
                                anchors.centerIn: parent
                                
                                source: themeData.wallpaper
                                sourceSize.height: parent.height
                                fillMode: Image.PreserveAspectCrop

                            }

                            Rectangle {
                                anchors.fill: parent
                                
                                border.width: strokeWidth
                                border.color: themeData.colors.accent2
                                color: "transparent"
                            }
                        }

                        RowLayout {
                            property int cubeWidth: 8
                            property int cubeHeight: 8

                            Layout.alignment: Qt.AlignHCenter
                            spacing: padding * 2
                            Layout.fillWidth: true

                            Rectangle {
                                implicitWidth: parent.cubeWidth
                                implicitHeight: parent.cubeHeight
                                rotation: 45

                                border.width: strokeWidth
                                border.color: themeData.colors.stroke

                                color: themeData.colors.bg
                            }

                            Rectangle {
                                implicitWidth: parent.cubeWidth
                                implicitHeight: parent.cubeHeight
                                rotation: 45

                                color: themeData.colors.accent
                            }

                            Rectangle {
                                implicitWidth: parent.cubeWidth
                                implicitHeight: parent.cubeHeight
                                rotation: 45

                                color: themeData.colors.accent2
                            }

                            Rectangle {
                                implicitWidth: parent.cubeWidth
                                implicitHeight: parent.cubeHeight
                                rotation: 45

                                color: themeData.colors.dark2
                            }

                            Rectangle {
                                implicitWidth: parent.cubeWidth
                                implicitHeight: parent.cubeHeight
                                rotation: 45

                                color: themeData.colors.dark3
                            }
                        }

                        Item {}
                    }
                }

                Item {
                    anchors.fill: parent
                    focus: true
                                    
                    Keys.onLeftPressed: function(key) { console.log("LEFT"); listView.currentIndex -= 1 }
                    Keys.onRightPressed: function(key) { console.log("RIGHT"); listView.currentIndex += 1 }

                }
            }
        }
    }
}