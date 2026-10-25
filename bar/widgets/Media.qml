import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Widgets
import QtQuick.Layouts

import Quickshell.Services.Mpris

import qs.bar.widgets

ColumnLayout {
    id: root

    property real averageLoudness: 0
    property int barCount: 5
    property string cavaConfig: [

        "[general]",
        "autosens = 1",
        "sensitivity = 100",
        "bars = " + barCount,
        "framerate = 60",

        "ower_cutoff_freq = 50",
        "igher_cutoff_freq = 20000",

        "[output]",
        "method = raw",
        "raw_target = /dev/stdout",
        "data_format = ascii",
        "ascii_max_range = 1000",
        "bar_delimiter = 59",   //  A SEMICOLON

        "channels = mono",

        "[smoothing]",
        "monstercat = 1",
        "waves = 0",
        "noise_reduction = 10",
    ].join("\\n")

    property var maxTitleLength: 150

    Layout.alignment: Qt.AlignHCenter
    implicitWidth: parent.width
    spacing: padding

    visible: media != null
    clip: true

    Text {
         font: normalFont
        color: Qt.lighter(getMediaColorsAdj()[1], 1.5) || theme.colors.accent
        text: "::"
    }
    
    Item {
        id: trackLabelLimits

        implicitWidth: parent.width
        implicitHeight: Math.min(trackLabel.implicitWidth, maxTitleLength) //mediaTitle.implicitWidth + (padding * 2)

        clip: true

       Text {
            id: trackLabel

            property real scrollFactor: 20
            property int pauseFactor: 2

            property var lengthDifference: (trackLabelLimits.height - implicitWidth) || 0
            property var idkWhyThisValueIsNeeded: trackLabelLimits.height - 10

            rotation: -90

            anchors.horizontalCenter: parent.horizontalCenter
            width: 1
            y: 180
            horizontalAlignment: Text.AlignLeft

            font: normalFont
            color: Qt.lighter(getMediaColorsAdj()[1], 1.5) || theme.colors.accent
            text: mediaTitle

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    trackLabel.lengthDifference = trackLabelLimits.height - trackLabel.implicitWidth || 0

                }
            }

            onLengthDifferenceChanged: {
                if (lengthDifference < 0 )  {
                    scrollAnim.restart()
                } else {
                    scrollAnim.stop()
                    trackLabel.y = idkWhyThisValueIsNeeded
                    
                }
            }

            SequentialAnimation {
                id: scrollAnim
                running: true
                loops: Animation.Infinite

                NumberAnimation { target: trackLabel; property: "y"; from: trackLabel.idkWhyThisValueIsNeeded; to: -(trackLabel.lengthDifference - trackLabel.idkWhyThisValueIsNeeded); duration: Math.abs(trackLabel.lengthDifference) * trackLabel.scrollFactor; easing.type: Easing.Linear }
                PauseAnimation { duration: trackLabel.pauseFactor * 1000 }
                NumberAnimation { target: trackLabel; property: "y"; from: -(trackLabel.lengthDifference - trackLabel.idkWhyThisValueIsNeeded); to: trackLabel.idkWhyThisValueIsNeeded; duration: Math.abs(trackLabel.lengthDifference) * trackLabel.scrollFactor; easing.type: Easing.Linear }
                PauseAnimation { duration: trackLabel.pauseFactor * 1000 }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton 
            hoverEnabled: true

            onClicked: function(mouse) {
                if (mouse.button == Qt.LeftButton) {
                    media.isPlaying = !media.isPlaying
                } else if (mouse.button == Qt.RightButton) {
                    media.next()
                } else if (mouse.button == Qt.MiddleButton) {
                    media.stop()
                }
            }

            onEntered: {
                root.opacity = 0.5

            }

            onExited: {
                root.opacity = 1

            }
        }
    }

    Item {}

    Rectangle {
        id: disc

        implicitWidth: root.width
        implicitHeight: root.width
        radius: width * 0.5

        color: mediaArt ? "transparent" : theme.colors.accent2

        ClippingWrapperRectangle {
            id: discImage

            anchors.fill: parent
            radius: parent.radius

            color: "transparent"

            Image {
                anchors.fill: parent
                source: mediaArt
            }

            Timer {
                interval: 50
                repeat: true
                running: true

                onTriggered: {
                    discImage.opacity = 0.5
                    
                    if (media && media.isPlaying) {
                        disc.rotation += 4
                        discImage.opacity = 1
                    }
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            
            implicitWidth: parent.width * 0.25
            implicitHeight: parent.height* 0.25
            radius: width * 0.5

            color: theme.colors.bg
        }
    }
}