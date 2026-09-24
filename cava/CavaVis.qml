import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import qs.bar.audio

Rectangle {
    id: root

    //anchors.fill: parent
    color: "transparent"

    clip: true

    property int barCount: 12
    property var barLevels: {
        let initialLevels = [];

        //  makes [barCount] number of levels inside barLevels, each at 0.0
        for (let i = 0; i < barCount; i++) {
            initialLevels.push(0.0);

        }
        return initialLevels;
    }
    

    property string cavaConfig: [

        "[general]",
        "autosens = 1",
        "sensitivity = 250",
        "bars = " + root.barCount,
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

    RowLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 6


        spacing: 1

        Repeater {
            model: barLevels

            Item {
                id: barContainer
                width: 2
                height: parent.height

                Rectangle {
                    anchors.bottom: parent.bottom

                    implicitWidth: parent.width
                    implicitHeight: Math.max(width, parent.height * modelData)

                    color: color_bright

                    Behavior on height {
                        NumberAnimation {
                            duration: 10
                            easing.type: EasingOutQuad
                        }
                    } 
                }
            }
        }
    }

    Process {
        id: cavaProcess
        running: true

        command: ["bash", "-c", "cava -p <(printf '" + root.cavaConfig + "\\n')"]

        stdout: SplitParser {
            onRead: data => {
                let cleanData = data.trim() //  REMOVES EMPTY CHARACTERS
                if (cleanData.length == 0) return;

                let tokens = cleanData.split(";")   //  REMEMBER "bar_delimiter = 59"?
                let availableTokens = Math.min(tokens.length, root.barCount)    //  IN CASE WE GET TOO MANY BARS
                let nextLevels = []

                for (let i = 0; i < root.barCount; i++) {
                    let rawAmp = i < availableTokens ? (parseInt(tokens[i]) || 0) : 0;  //  GUARD AGAINST WEIRD STUFF, SET IT TO 0 IF WEIRD STUFF HAPPENS
                    let normalizedLevel = Math.max(0.0, Math.min(1.0, rawAmp / 1000.00));    //  AMPLITUDE SET TO A VALUE BETWEEN 0 AND 1 - NORMALIZATIOn
                    nextLevels.push(normalizedLevel);

                }

                root.barLevels = nextLevels;
            }
        }
    }
}
