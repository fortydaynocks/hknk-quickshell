import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.Notifications
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent
    anchors.margins: padding * 2

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodySupported: true
        imageSupported: false
        keepOnReload: false
        onNotification: notif => {
            notif.tracked = true

        }

        function dismissAll() {
            let collectedNotifs = [];

            for (let notif of notifServer.trackedNotifications.values) {
                collectedNotifs.push(notif)
            }

            for (let notif of collectedNotifs) {
                notif.dismiss()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: padding * 2

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 30

            color: theme.colors.accent

            Item {
                anchors.fill: parent
                anchors.margins: padding

                RowLayout {
                    anchors.fill: parent
                    spacing: padding
                    
                    Text {
                        Layout.alignment: Qt.AlignLeft

                        font: normalFont
                        color: theme.colors.bg

                        text:"󰂚 NOTIFICATIONS"
                    }

                    Rectangle {
                        id: clearButton
                        Layout.alignment: Qt.AlignRight
                        Layout.fillHeight: true
                        implicitWidth: 80

                        color: theme.colors.bg
                        visible: notifServer.trackedNotifications.values.length > 0

                        Text {
                            id: clearText
                            anchors.centerIn: parent

                            font: normalFont
                            color: theme.colors.accent2

                            text:" CLEAR"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            hoverEnabled: true

                            onClicked: function(mouse) { if (mouse.button == Qt.LeftButton) {
                                notifServer.dismissAll()
                                }
                            }

                            onEntered: {
                                clearButton.color = theme.colors.accent2
                                clearText.color = theme.colors.accent

                            }

                            onExited: {
                                clearButton.color = theme.colors.bg
                                clearText.color = theme.colors.accent2

                            }
                        }
                    }
                }
            } 
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: padding * 2

                Repeater {
                    model: notifServer.trackedNotifications

                    delegate: Rectangle {
                        id: notifPanel

                        required property var modelData

                        property var hovering: false

                        Layout.fillWidth: true
                        implicitHeight: 50

                        border.width: strokeWidth
                        border.color: theme.colors.dark1

                        color: theme.colors.bg
                        
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
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 0
                                
                                Text {
                                    Layout.alignment: Text.AlignLeft
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight

                                    font: normalFont
                                    color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.critical : theme.colors.accent
                                    
                                    

                                    text: ":: " + modelData.summary.toUpperCase()
                                }

                                Text {
                                    Layout.alignment: Text.AlignLeft
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight

                                    font: normalFont
                                    color: theme.colors.dark3

                                    text: modelData.body
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            hoverEnabled: true

                            onClicked: function(mouse) { if (mouse.button == Qt.LeftButton && !notifPanel.dismissing) {
                                notifPanel.dismiss()
                                }
                            }

                            onEntered: {
                                notifPanel.opacity = 0.5
                            }

                            onExited: {
                                notifPanel.opacity = 1
                            }
                        }

                        function dismiss() {
                            modelData.dismiss()
                            //dismissNotif.start()
                        }
                    }
                }
            }
        }   
    }
}