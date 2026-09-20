import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.components

Rectangle {
    id: root

    property var media: Mpris.players.values[Mpris.players.values.length - 1]

    property var media_position: media.position ? Math.floor(media.position / 60): 0
    property var media_length: media.length ? Math.floor(media.length / 60) : 0
    property var media_position_remainder: media.position ? Math.floor(media.position % 60) : 00
    property var media_length_remainder: media.length ? Math.floor(media.length % 60) : 00

    implicitWidth: media ? row.width + 20 : 0
    implicitHeight: barHeight
    color: color_dark

    clip: true

    Image {
        anchors.centerIn: parent

        width: parent.width
        height: parent.width
        opacity: 0.1

        source: media.trackArtUrl
    }

    //  ===== PLAY - PAUSE! ==========
    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 5

        Rectangle {
            id: playerIcon

            implicitWidth: playerIconLabel.width + 16
            implicitHeight: barHeight - 8

            color: media.isPlaying ? color_bright : color_dark

            Text {
                id: playerIconLabel

                anchors.centerIn: parent

                font: normalFont
                color: media.isPlaying ? color_dark : color_bright
                text: (media.trackTitle && media.isPlaying) ? "" : ""

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.OutCirc
                        duration: 200
                    }
                }
            }

            MouseArea{
                anchors.fill: parent

                hoverEnabled: true

                onClicked: function(mouse) {
                   if (mouse.button == Qt.LeftButton) {
                       media.isPlaying = !media.isPlaying
                    }
                }

                onEntered: {
                    playerIcon.opacity = 0.5

                }

                onExited: {
                    playerIcon.opacity = 1

                }
            }

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }
        }

        Separator {}

        //  ===== INFO! ==========
        Text {
            id: artistLabel

            font: normalFont
            color: color_bright
            text: media.trackArtist || "?"
        }

        Rectangle {
            id: trackLabelBG

            implicitWidth: trackLabel.implicitWidth + 8
            implicitHeight: 16 //trackLabel.height
            
            color: color_bright
           // border.color: color

            clip: true

            Text {
                id: trackLabel
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font: normalFont
                color: color_dark

                text: media.trackTitle || ""
            }

            //  ===== SKIP! ==========
            MouseArea{
                anchors.fill: parent

                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: function(mouse) {
                    if (mouse.button == Qt.LeftButton) {
                       media.next()
                    }
                    else if (mouse.button == Qt.RightButton) {
                       media.previous()
                    }
                }

                onWheel: function(wheel) {
                    if (media && media.canSeek && media.positionSupported) {
                        var dist = wheel.angleDelta.y / 60
                        media.position += dist

                    }
                }

                onEntered: {
                    trackLabelBG.opacity = 0.5

                }

                onExited: {
                    trackLabelBG.opacity = 1

                }
            }

            Behavior on opacity {
                NumberAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }
        }

        BracketLeft { color: color_dark2 }

        //  ===== SEEKER ==========
        Rectangle {
            id: trackSeeker

            implicitWidth: media ? 100 : 0
            implicitHeight: 5

            color: "transparent"

            Rectangle {
                id: trackSeekerFill

                implicitWidth: (parent.width) * (media.position / media.length)
                implicitHeight: parent.height

                color: color_bright
            }
        }

        BracketRight { color: color_dark2 }

        Text {
            id: trackTime

            property var text_format: media_position + ":" + media_position_remainder.toString().padStart(2, "0") //+ " - " + media_length + ":" + media_length_remainder.toString().padStart(2, "0")

            font: normalFont

            color: color_dark3
            text: media ? text_format : ""

            Timer {
                running: media.playbackState == MprisPlaybackState.Playing
                interval: 100
                repeat: true

                onTriggered: media.positionChanged()
            }
        }

       // BracketRight { color: color_dark2 }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 400
        }
    }
}