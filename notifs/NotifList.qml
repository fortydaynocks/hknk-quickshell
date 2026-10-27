//@pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Hyprland

PopupWindow {
    id: root

    property var imOnTheActiveScreen: Hyprland.focusedMonitor.name == panel.screen.name
    property int maxHeight: 400
    property int notifHeight: 60
    property int notifTimeout: 6

    anchor.window: gapRight
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.rect.x: -padding
    anchor.rect.y: borderSize + padding

    implicitWidth: 500
    implicitHeight: Math.min(Math.max(layout.implicitHeight, 1), maxHeight)

    color: "transparent"
    visible: layout.children.length > 0 && imOnTheActiveScreen

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodySupported: true
        imageSupported: false
        onNotification: notif => {
            notif.tracked = true

        }
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: padding

            Repeater {
                model: notifServer.trackedNotifications

                delegate: Rectangle {
                    id: notifPanel

                    required property var modelData

                    property var timeLeft: notifTimeout
                    property var hovering: false
                    property var dismissing: false

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
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 0
                            
                            Text {
                                Layout.alignment: Text.AlignLeft
                                Layout.fillWidth: true
                                elide: Text.ElideRight

                                font: bigFont
                                color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.critical : theme.colors.accent
                                
                                

                                text: ":: " + modelData.summary.toUpperCase()
                            }

                            Text {
                                Layout.alignment: Text.AlignLeft
                                Layout.fillWidth: true
                                elide: Text.ElideRight

                                font: normalFont
                                color: theme.colors.dark3

                                text: " " + modelData.body
                            }
                            
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: strokeWidth
                                visible: modelData.urgency != NotificationUrgency.Critical && !hovering

                                color: theme.colors.dark2
                                
                                Rectangle {
                                    anchors.left: parent.left
                                    implicitHeight: parent.height

                                    implicitWidth: parent.width * (notifPanel.timeLeft / root.notifTimeout)

                                    color: theme.colors.accent
                                }
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
                                id: overlayText

                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                font: bigFont
                                color: modelData.urgency == NotificationUrgency.Critical ? theme.colors.bg : theme.colors.accent2

                                text: modelData.urgency == NotificationUrgency.Critical ? "!   C R I T I C A L" : "!   N O T I F Y"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        hoverEnabled: true

                        onClicked: function(mouse) { if (mouse.button == Qt.LeftButton && !notifPanel.dismissing) {
                            notifPanel.dismissing = true
                            dismiss()
                            }
                        }

                        onEntered: {
                            notifPanel.opacity = 0.5
                            notifPanel.hovering = true; stopTimer()
                        }

                        onExited: {
                            notifPanel.opacity = 1
                            notifPanel.hovering = false; startTimer()
                        }
                    }

                    function startTimer() {
                        if (modelData.urgency != NotificationUrgency.Critical) {
                            notifTimer.start()
                            notifTimerAnim.start()
                        }
                    }

                    function stopTimer() {
                        notifPanel.timeLeft = root.notifTimeout

                        notifTimer.stop()
                        notifTimerAnim.stop()
                    }

                    function dismiss() {
                        dismissNotif.start()
                    }

                    Timer {
                        id: notifTimer

                        interval: root.notifTimeout * 1000
                        onTriggered: { notifPanel.visible = false }
                    }

                    SequentialAnimation {
                        id: notifTimerAnim

                        //PropertyAction { target: notifPanel; property: "timeLeft"; value: root.notifTimeout }
                        NumberAnimation { target: notifPanel; property: "timeLeft"; from: root.notifTimeout; to: 0; duration: root.notifTimeout * 1000 }
                    }

                    SequentialAnimation {
                        id: showNotif
                        running: true

                        NumberAnimation { target: notifPanel; property: "implicitWidth"; from: 0; to: layout.width; duration: 400; easing.type: Easing.OutCirc }
                        PauseAnimation { duration: 200 }
                        NumberAnimation { target: blueOverlay; property: "implicitWidth"; to: 0; duration: 200; easing.type: Easing.OutCirc }     
                        ScriptAction { script: notifPanel.startTimer() }
                    }

                    SequentialAnimation {
                        id: dismissNotif

                        PropertyAction { target: overlayText; property: "text"; value: "󰄬 D I S M I S S " }
                        NumberAnimation { target: blueOverlay; property: "implicitWidth"; to: blueOverlay.parent.width; duration: 200; easing.type: Easing.OutCirc } 
                        PauseAnimation { duration: 200 }
                        NumberAnimation { target: notifPanel; property: "implicitWidth"; to: 0; duration: 200; easing.type: Easing.OutCirc }
                        ScriptAction { script: modelData.dismiss() }
                    }

                    Behavior on Layout.preferredHeight {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCirc }
                    }
                }
            }
        }
    }
}
