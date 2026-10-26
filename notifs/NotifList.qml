import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Services.Notifications

PopupWindow {
    id: root

    property int maxHeight: 400
    property int notifHeight: 60

    anchor.window: gapRight
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.rect.x: -padding
    anchor.rect.y: borderSize + padding

    implicitWidth: 500
    implicitHeight: Math.min(Math.max(layout.implicitHeight, 1), maxHeight)

    color: "transparent"
    visible: true

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: notif => {
            console.log("got:", notif.summary, "body:", notif.body)
            notif.tracked = true

        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: padding

        Repeater {
            model: notifServer.trackedNotifications

            delegate: Rectangle {
                id: notifPanel
                required property var modelData

                Layout.alignment: Qt.AlignRight
                implicitWidth: layout.width
                implicitHeight: notifHeight

                border.width: strokeWidth
                border.color: theme.colors.stroke

                color: theme.colors.bg
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: padding * 2
                    spacing: padding

                    Rectangle {
                        implicitWidth: strokeWidth * 2
                        implicitHeight: parent.height

                        color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.critical : theme.colors.accent
                    }

                    ColumnLayout {
                        Layout.fillHeight: true
                        spacing: 0
                        
                        Text {
                            font: bigFont
                            color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.critical : theme.colors.accent

                            text: ":: " + modelData.summary.toUpperCase()
                        }

                        Text {
                            font: normalFont
                            color: theme.colors.dark3

                            text: modelData.body
                        }
                    }
                }

                Rectangle {
                    id: blueOverlay

                    anchors.left: parent.left
                    //anchors.margins: padding

                    implicitWidth: parent.width
                    implicitHeight: parent.height

                    color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.critical : theme.colors.accent
                    clip: true

                    Item {
                        anchors.fill: parent
                        anchors.margins : padding * 2

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            font: bigFont
                            color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.bg : theme.colors.accent2

                            text:  modelData.urgency == NotificationUrgency.Critical ? "!   C R I T I C A L" : "!   N O T I F Y"
                        }
                    }
                }

                SequentialAnimation {
                    id: showNotif
                    running: true

                    PropertyAction { target: notifPanel; property: "implicitWidth"; value: 0 }
                    NumberAnimation { target: notifPanel; property: "implicitWidth"; to: layout.width; duration: 200; easing.type: Easing.OutCirc }
                    NumberAnimation { target: blueOverlay; property: "implicitWidth"; to: 0; duration: 200; easing.type: Easing.OutCirc }                
                }
            }
        }
    }
}