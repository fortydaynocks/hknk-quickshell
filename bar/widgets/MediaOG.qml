import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.bar.widgets

Rectangle {
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
    property string usedTrackName: trackName.length > maxTrackLength ? trackMarqueeName : trackName
    
    property var maxTrackLength: 20

    implicitWidth: media ? row.width: 0
    implicitHeight: barSize
    color: "transparent"

    clip: true

    //  ===== PLAY - PAUSE! ==========
    ColumnLayout {
        id: row

        anchors.centerIn: parent
        spacing: padding / 2

        Rectangle {
            id: startStop

            implicitWidth: barSize * 0.5
            implicitHeight: barSize * 0.5

            color: media && media.isPlaying ? theme.colors.accent : "transparent"

            Text {
                anchors.centerIn: parent

                font: normalFont
                color: media && media.isPlaying ? theme.colors.dark1 : theme.colors.accent

                text: media && media.isPlaying ? "󰏤" : ""
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: function(mouse) {
                    if (mouse.button == Qt.LeftButton && media) {
                        media.isPlaying = !media.isPlaying
                        
                    }
                }

                onEntered: {
                    startStop.opacity = 0.5

                }

                onExited: {
                    startStop.opacity = 1

                }
            }
        }

        Rectangle {
            implicitWidth: barSize * 0.5
            implicitHeight: barSize * 0.5

            color: theme.colors.accentdark

            Text {
                anchors.centerIn: parent

                font: normalFont
                color: theme.colors.bg

                text: "󰓛"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: function(mouse) {
                    if (mouse.button == Qt.LeftButton && media) {
                        media.stop()
                        
                    }
                }

                onEntered: {
                    startStop.opacity = 0.5

                }

                onExited: {
                    startStop.opacity = 1

                }
            }
        }

        Item {}

        Text {
            id: artistLabel

            font: normalFont
            color: theme.colors.dark1

            text: "󰝚 " +  media.trackArtist || "?"

            Text {
                font: normalFont
                color: theme.colors.accent
                opacity: media ? averageLoudness : 0

                text: parent.text
            }
        }

        Cava {
            id: cava

            implicitWidth: media.isPlaying ? 60 : 0
            implicitHeight: root.height
        }
        
        Separator { text: "::"; color: theme.colors.dark2 }

        Text {
            id: trackLabel
            
            font: normalFont
            color: media.isPlaying ? theme.colors.accent : theme.colors.dark2

            text: usedTrackName || ""
        }

        Separator { text: "::"; color: theme.colors.dark2 }
    }

    Process {
        id: cavaProcess
        running: true

        command: ["bash", "-c", "cava -p <(printf '" + cavaConfig + "\\n')"]

        stdout: SplitParser {
            onRead: data => {
                var avg = 0
                let avgTotal = []

                let cleanData = data.trim() //  REMOVES EMPTY CHARACTERS
                if (cleanData.length == 0) return

                let tokens = cleanData.split(";")   //  REMEMBER "bar_delimiter = 59"?
                let availableTokens = Math.min(tokens.length, root.barCount)    //  IN CASE WE GET TOO MANY BARS
                
                for (let i = 0; i < root.barCount; i++) {
                    

                    let rawAmp = i < availableTokens ? (parseInt(tokens[i]) || 0) : 0  //  GUARD AGAINST WEIRD STUFF, SET IT TO 0 IF WEIRD STUFF HAPPENS
                    let normalizedLevel = Math.max(0.0, Math.min(1.0, rawAmp / 1000.00))    //  AMPLITUDE SET TO A VALUE BETWEEN 0 AND 1 - NORMALIZATIOn

                    avg += normalizedLevel
                    avgTotal.push(normalizedLevel)

                }
                
                averageLoudness = avg / avgTotal.length
            }
        }
    }

    Timer {
        running: true
        interval: 100
        repeat: true

        onTriggered: {
            let extendedMaxTrackLength = maxTrackLength + trackMarqueeAddition
            let fullTrackName = trackName.padEnd(trackName.length + trackMarqueeAddition, " ")
            let formattedTrackName = fullTrackName.slice(trackMarqueeIndex, maxTrackLength + trackMarqueeIndex)

            if (media.isPlaying) {
                if (formattedTrackName.length < maxTrackLength) {
                    let remainder = maxTrackLength - formattedTrackName.length
                    formattedTrackName += fullTrackName.slice(0, remainder)
                }

                trackMarqueeName = formattedTrackName
                trackMarqueeIndex += 1
                if (trackMarqueeIndex > fullTrackName.length - 1) {trackMarqueeIndex = 0}
            } else {
                trackMarqueeIndex = 0
                trackMarqueeName = formattedTrackName

            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 400
        }
    }
}