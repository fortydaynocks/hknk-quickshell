pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property int barCount: 1
    property var barLevels: {
        let initialLevels = [];

        //  makes [barCount] number of levels inside barLevels, each at 0.0
        for (let i = 0; i < barCount; i++) {
            initialLevels.push(0.0);

        }
        return initialLevels;
    }

    readonly property string cavaConfig: [

        "[general]",
        "autosens = 0",
        "sensitivity = 1000",
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