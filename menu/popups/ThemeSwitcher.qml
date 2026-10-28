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

    property var imOnTheActiveScreen: Hyprland.focusedMonitor.name == panel.screen.name
    //property var windowOpen: false

    anchor.window: panel

    anchor.rect.x: (Screen.width - implicitWidth) / 2
    anchor.rect.y: (Screen.height - implicitHeight) / 2

    implicitWidth: 800
    implicitHeight: 400

    color: "transparent"

    visible: visible && imOnTheActiveScreen
    grabFocus: true
    //mask: Region {}

    
    Item {
        id: itemContainer
        anchors.left: parent.left
        
        implicitWidth: parent.width / 2
        implicitHeight: parent.height

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
                    spacing: padding * 2

                    //highlight: Rectangle {  implicitHeight: listView.height; implicitWidth: 100; color: theme.colors.stroke; opacity: 0.25 }
                    highlightMoveDuration: 250
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: (root.implicitWidth * 0.45) - 10
                    preferredHighlightEnd: (root.implicitWidth * 0.45) + 10

                    snapMode: ListView.SnapToItem
                    keyNavigationWraps: true
                    orientation: Qt.Horizontal
                    
                    model: folderModel
                    clip: true

                    currentIndex: dataJson.adapter.chosenThemeIndex || 0

                    FolderListModel {
                        id: folderModel
                        folder: shellRoot.themesPath
                        nameFilters: ["*.json"]

                    }

                    delegate: Item {
                        required property string fileName
                        required property string fileUrl
                        readonly property var themeData: JSON.parse(newThemeJson.text())


                        property var selected: ListView.isCurrentItem
                        //font: normalFont
                        //color: theme.colors.accent2

                        //text: fileName + "..."

                        implicitHeight: listView.height //  DON'T USE "parent", IT CAN SOMETIMES BE NULL.
                        implicitWidth: 100

                        opacity: selected ? 1 : 0.25
                        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCirc } }

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

                            Item {}

                            Text {
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true

                                font: normalFont
                                color: theme.colors.accent2
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

                                    border.width: 1
                                    border.color: themeData.colors.stroke

                                    color: themeData.colors.bg
                                }

                                Rectangle {
                                    implicitWidth: parent.cubeWidth
                                    implicitHeight: parent.cubeHeight
                                    rotation: 45

                                    border.width: 1
                                    border.color: themeData.colors.bg

                                    color: themeData.colors.accent
                                }

                                Rectangle {
                                    implicitWidth: parent.cubeWidth
                                    implicitHeight: parent.cubeHeight
                                    rotation: 45

                                    border.width: 1
                                    border.color: themeData.colors.accent

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
                }
            }
        }

        Rectangle {
        id: blueOverlay

        anchors.right: parent.right
        implicitWidth: parent.width;
        implicitHeight: parent.height;

        color: theme.colors.accent
        clip: true

            Text {
                id: overlayText

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                font: bigFont
                color: theme.colors.bg

                text: "T H E M E S   󰏘 " 
            }
        }

        SequentialAnimation {
            id: showMenu

            NumberAnimation { target: itemContainer; property: "implicitWidth"; from: 0; to: root.width; duration: 200; easing.type: Easing.OutCirc }
            //PropertyAction { target: menuFill; property: "opacity"; value: 1 }
            NumberAnimation { target: blueOverlay; property: "implicitWidth"; to: 0; duration: 200; easing.type: Easing.OutCirc }
        }
    }

    onVisibleChanged: {
        if (root.visible == true) {
            showMenu.restart()
        }
    }

    function updateTheme(whichItem) {
        let themeUrl = whichItem.fileUrl || shellRoot.themePath

        dataJson.adapter.chosenThemeIndex = listView.currentIndex
        shellRoot.updateTheme(themeUrl, whichItem.themeData)

        visible = false
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onLeftPressed: listView.decrementCurrentIndex()
        Keys.onRightPressed: listView.incrementCurrentIndex()

        Keys.onReturnPressed: { updateTheme(listView.currentItem) }
        Keys.onEnterPressed: { updateTheme(listView.currentItem) }
        Keys.onEscapePressed: { root.visible = false }
    }
}