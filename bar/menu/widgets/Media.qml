import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Widgets
import QtQuick.Layouts

import Quickshell.Services.Mpris

import qs.bar.widgets

Item {
    id: root

    property var media: shellRoot.media

    property real scrollFactor: 25
    property int pauseFactor: 2

    anchors.fill: parent
    clip: true

    Image {
        anchors.centerIn: parent
        
        fillMode: Image.PreserveAspectCrop
        width: root.width

        source: mediaArt || shellRoot.mediaArtPlaceholder
        cache: false
        opacity: 0.2
    }

    Item {
        anchors.fill: parent
        anchors.margins: padding * 2

        RowLayout {
            anchors.fill: parent
            spacing: padding

            Rectangle {
                Layout.fillHeight: true
                implicitWidth: strokeWidth

                color: Qt.lighter(getMediaColorsAdj()[1], 1.5) || theme.colors.accent
            }

            Text {
                font.family: theme.font.family
                font.bold: true
                font.pointSize: 10

                color: getMediaColorsAdj()[1] || theme.colors.accent
                text: "::"
            }

            Item {
                Layout.fillWidth: true
                implicitHeight: parent.height
                clip: true

                Text {
                    id: trackLabel
 
                    property var lengthDifference: (parent.width - implicitWidth) || 0

                    anchors.verticalCenter: parent.verticalCenter

                    x: 0

                    font.family: theme.font.family
                    font.bold: true
                    font.pointSize: 10

                    color: Qt.lighter(getMediaColorsAdj()[1], 1.5) || theme.colors.accent
                    text: mediaTitle

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true

                        onTriggered: {
                            trackLabel.lengthDifference = trackLabel.parent.width - trackLabel.implicitWidth || 200

                        }
                    }

                    onLengthDifferenceChanged: {
                        if (lengthDifference < 0 )  {
                            scrollAnim.restart()
                        } else {
                            trackLabel.x = 0
                            scrollAnim.stop()
                        }
                    }

                    SequentialAnimation {
                        id: scrollAnim
                        running: true
                        loops: Animation.Infinite

                        NumberAnimation { target: trackLabel; property: "x"; from: 0; to: trackLabel.lengthDifference; duration: Math.abs(trackLabel.lengthDifference) * scrollFactor; easing.type: Easing.Linear }
                        PauseAnimation { duration: root.pauseFactor * 1000 }
                        NumberAnimation { target: trackLabel; property: "x"; from: trackLabel.lengthDifference; to: 0; duration: Math.abs(trackLabel.lengthDifference) * scrollFactor; easing.type: Easing.Linear }
                        PauseAnimation { duration: root.pauseFactor * 1000 }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.fillHeight: true
                spacing: padding


                //  PLAY/PAUSE/STOP

                Rectangle {
                    implicitWidth: parent.parent.height
                    implicitHeight: parent.parent.height
                    color: getMediaColorsAdj()[1] || theme.colors.accent

                    Text {
                        anchors.centerIn: parent
                        
                        font.family: theme.font.family
                        font.bold: true
                        font.pointSize: 14

                        color: Qt.darker(getMediaColorsAdj()[0], 2.5) || theme.colors.bg
                        text: mediaPlaying ? "󰏤" : "󰐊"
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        hoverEnabled: true

                        onClicked: function(mouse) {
                            if (!media) { return }

                            if (mouse.button == Qt.LeftButton) {
                                media.isPlaying = !media.isPlaying
                            } else if (mouse.button == Qt.MiddleButton) {
                                media.stop()
                            }
                        }

                        onEntered: {
                            parent.opacity = 0.5

                        }

                        onExited: {
                            parent.opacity = 1

                        }
                    }

                }

                //  NEXT/PREV

                Rectangle {
                    implicitWidth: parent.parent.height
                    implicitHeight: parent.parent.height
                    color: getMediaColorsAdj()[1] || theme.colors.accent
                    
                    Text {
                        anchors.centerIn: parent
                        
                        font.family: theme.font.family
                        font.bold: true
                        font.pointSize: 14

                        color: Qt.darker(getMediaColorsAdj()[0], 2.5) || theme.colors.bg
                        text: "󰒭"
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true

                        onClicked: function(mouse) {
                            if (!media) { return }

                            if (mouse.button == Qt.LeftButton) {
                                media.next()
                            } else if (mouse.button == Qt.RightButton) {
                                media.previous()
                            }
                        }

                        onEntered: {
                            parent.opacity = 0.5

                        }

                        onExited: {
                            parent.opacity = 1

                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent

        border.width: strokeWidth
        border.color: getMediaColorsAdj()[0] || theme.colors.stroke

        color: "transparent"
    }
}