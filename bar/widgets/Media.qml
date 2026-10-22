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

    
    property var foundMedia: Mpris.players.values[Mpris.players.values.length - 1]
    property var media: foundMedia
    
    property string trackName: media.trackTitle
    property string trackMarqueeName: ""
    property int trackMarqueeIndex: 0
    property int trackMarqueeAddition: 15
    property string usedTrackTitle: media.trackTitle
    
    property string trackArt: media.trackArtUrl

    Layout.alignment: Qt.AlignHCenter
    implicitWidth: parent.width
    spacing: padding

    clip: true

    ColorQuantizer {
        id: colorQ
        source: trackArt

        depth: 1
        rescaleSize: 32
    }
    
    Rectangle {
        implicitWidth: parent.width
        implicitHeight: trackTitle.implicitWidth + (padding * 2)

        color: "transparent"

        Rectangle {

            anchors.fill: parent
            color: colorQ.colors[0]
            opacity: 0.4
        }

        Text {
            id: trackTitle
            anchors.centerIn: parent
            rotation: -90

            font: normalFont
            color: colorQ.colors[1]
            text: usedTrackTitle + " ::" || ""
        }

        
    }

    Item {}

    Rectangle {
        id: disc

        implicitWidth: root.width
        implicitHeight: root.width
        radius: width * 0.5

        color: theme.colors.stroke

        ClippingWrapperRectangle {
            id: discImage

            anchors.fill: parent
            radius: parent.radius

            color: theme.colors.stroke

            Image {
                anchors.fill: parent
                source: trackArt
            }

            Timer {
                interval: 50
                repeat: true
                running: true

                onTriggered: {
                    //discImage.opacity = 0.5
                    
                    if (media && media.isPlaying) {
                        disc.rotation += 4
                        //discImage.opacity = 1
                    }
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            
            implicitWidth: parent.width * 0.25
            implicitHeight: parent.height* 0.25
            radius: width * 0.5

            color: theme.colors.black
        }
    }

    Connections {
        target: media

        function onTrackArtUrlChanged () {
            console.log(media.trackArtUrl)

            var newArt = media.trackArtUrl
            if (newArt && newArt !== "") { trackArt = newArt }
        }
    }

    Timer {
        interval: 150
        running: true
        repeat: true

        property int maxTrackNameLength: 14
        property int trackNameIndex: 0
        property int marqueeSpacing: 10

        onTriggered: {
            if (media.trackTitle.length > maxTrackNameLength) {
                var fullTrackTitle = media.trackTitle + " ".repeat(maxTrackNameLength)
                usedTrackTitle = fullTrackTitle.substr(trackNameIndex, maxTrackNameLength)

                if (trackNameIndex > media.trackTitle.length) {
                    usedTrackTitle += fullTrackTitle.substr(0, trackNameIndex - media.trackTitle.length)
                }
                
                trackNameIndex = (trackNameIndex + 1) % fullTrackTitle.length
            } else {
                usedTrackTitle = media.trackTitle
                trackNameIndex = 0
            }
        }
    }
}