
//@ pragma UseQApplication
// must remain commented. used for system tray functionality.

import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Hyprland

import qs.theme
import qs.bar
import qs.desktop

Scope {
    id: shellRoot

    // PATHS
    property var themePath: Quickshell.shellPath("data/theme.json")
    property var themesPath: Qt.resolvedUrl("theme/themes")
    property var dataPath: Quickshell.shellPath("data/myData.json")
    property string hellwalPath: Quickshell.shellPath("./theme/hellwalColors.json")
    property var wallpapers: Qt.resolvedUrl("theme/wallpapers")

    //  THEMING
    property var theme: ThemeManager.theme
    property var themeColors: ThemeManager.themeColors
    
    property var normalFont: ThemeManager.normalFont
    property var lightFont: ThemeManager.normalFont
    property var smallFont: ThemeManager.smallFont
    property var bigFont: ThemeManager.bigFont

    //  TIME
    property string timeH: ""
    property string timeM: ""
    property string date: ""

    //  MEDIA
    property var media: Mpris.players.values[Mpris.players.values.length - 1] || null
    property var mediaArtist: media ? media.trackArtist : "?"
    property var mediaTitle: media ? media.trackTitle : ""
    property var mediaArtPlaceholder: ""//Qt.resolvedUrl(Quickshell.shellPath("images/audio-placeholder.png"))
    property var mediaArt: media ? media.trackArtUrl : mediaArtPlaceholder
    property var mediaPlaying: media ? media.isPlaying : false
    
    //  BATTERY
    property var battery: UPower.displayDevice.isLaptopBattery ? UPower.displayDevice : null
    property real batteryPercentage: battery ? battery.percentage : 0
    property int maxBatteryPercentage: 100

    //  HYPRLAND
    property var hyprMonitors: Hyprland.monitors
    property var hyprThisMonitor: Hyprland.focusedMonitor
    
    //  OBJECTS
    Bar {}
    Desktop {}

    //  CONNECTIONS
    Connections {
        target: media

        function onTrackArtUrlChanged () {
            if (!media) { return }

            var newArt = media.trackArtUrl
            if (newArt && newArt != "") { mediaArt = newArt }

        }
    }

    ColorQuantizer {
        id: colorQ
        source: mediaArt || mediaArtPlaceholder

        depth: 1
        rescaleSize: 32
    }

    function getMediaColors() {
        return colorQ.colors
    }

    function getMediaColorsAdj() {
        let colors = getMediaColors()
        let newColors = []
        let minValue = 0.3

        for (let color of colors) {
            let newColor = Qt.hsva(color.hsvHue, color.hsvSaturation, Math.max(color.hsvValue, minValue), color.a)
            newColors.push(newColor)
        }

        return newColors
    }

    //  DATA
    FileView {
        id: dataJson
        path: dataPath

        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        adapter: JsonAdapter {
            id: myData

            property string chosenTheme: ""
            property int chosenThemeIndex: 0
            property string wallpaper: ""
        }
    }

    FileView {
        id: themeFV
        path: themePath

        watchChanges: true

        onFileChanged: { reload(); updateColors() }
    }

    //  THEME SWITCHING
    //function reload(hard = false) {
        //Quickshell.reload(hard)
    //}
    function trimmedColor(color) {
       
    }

    function cmd(doThis) {
        Quickshell.execDetached( { command: ["sh", "-c", doThis] } )
    }

    Process {
        id: configEditor

        property var commandQueue: []

        command: []

        onExited: {
            if (commandQueue.length > 0) {
                configEditor.command = configEditor.commandQueue[0]
                configEditor.running = true

                configEditor.commandQueue.shift()
            }
        }

        function addCommand(cmd) {
            configEditor.commandQueue.push(cmd)

            if (!configEditor.running) {
                console.log(configEditor.commandQueue.toString())
                configEditor.command = cmd
                configEditor.running = true

            }
        }

        function edit(configPath, parameter,  denominator = "=", value, mode = "fuzzelColor") {
            if (!configPath) { return }

            let patchedValue = value

            if (mode == "fuzzelColor") {
                patchedValue = patchedValue.toString().replace("#", "")
                if (patchedValue.length == 8) {
                    patchedValue = patchedValue.slice(2, patchedValue.length) + patchedValue.slice(0, 2)
                }
                else {
                    patchedValue += "ff"
                }
            }

            if (mode == "kittyColor") {
                if (patchedValue.length >= 8) {
                    patchedValue = "#" + patchedValue.slice(3, patchedValue.length)
                }
            }

            console.log("during: ", parameter, "=", value)
            configEditor.addCommand(["sh", "-c", "sed -i 's/" + parameter + denominator + ".*/" + parameter + denominator + patchedValue + "/' " + configPath])
        }
    }

    

    function updateTheme(wallpaper) {
        myData.wallpaper = wallpaper

        //cmd("swaybg -i " + wallpaper)
        cmd("awww img '" + wallpaper + "' --transition-type center --transition-duration 1")
        cmd("hellwal -i '" + wallpaper + "' -j > " + hellwalPath)
    }

    function updateColors() {
        //  RUNS AFTER THE THEME FILE'S CONTENT IS UPDATED

        //  HYPRLAND
        cmd("hyprctl reload")

        //  FUZZEL
        //Quickshell.execDetached( { command: ["sh", "-c",
            //"sed -i 's/background=.*/background=" + theme.colors.bg + "/' ~/.config/fuzzel/fuzzel.ini"
        //] } )
        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "background", "=", theme.colors.bg, "fuzzelColor")
        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "border", "=", theme.colors.accent, "fuzzelColor")

        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "text", "=", theme.colors.accent, "fuzzelColor")
        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "match", "=", theme.colors.accent2, "fuzzelColor")

        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "selection", "=", theme.colors.accent2, "fuzzelColor")
        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "selection-text", "=", theme.colors.dark3, "fuzzelColor")
        configEditor.edit("~/.config/fuzzel/fuzzel.ini", "selection-match", "=", theme.colors.bg, "fuzzelColor")

        console.log("after: ", theme.colors.bg)

        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/background=.*/background=" + fuzzelColor(themeData.colors.bg) + "/' ~/.config/fuzzel/fuzzel.ini"] } )
        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/border=.*/border=" + fuzzelColor(themeData.colors.stroke) + "/' ~/.config/fuzzel/fuzzel.ini"] } )
        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/text=.*/text=" + fuzzelColor(themeData.colors.dark3) + "/' ~/.config/fuzzel/fuzzel.ini"] } )

        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/selection=.*/selection=" + fuzzelColor(themeData.colors.dark3) + "/' ~/.config/fuzzel/fuzzel.ini"] } )

        //cmd("kitten @ set-colors background=" + trimmedColor(themeData.colors.background))
        //cmd("kitten @ set-colors foreground=" + trimmedColor(themeData.colors.dark3))
        
        //  HYPRLAND    --  UPDATED ABOVE, WEHN THE THEME CHANGES
        //Quickshell.execDetached( { command: ["sh", "-c", "hyprctl reload"] } )
    }

    //  TIME
    Process {
        id: timeProcessH

        command: ["bash", "-c", "date '+%H'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeH = text.trim()
        }
    }

    Process {
        id: timeProcessM

        command: ["bash", "-c", "date '+%M'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: timeM = text.trim()
        }
    }

    Process {
        id: dateProcess

        command: ["bash", "-c", "date '+%a %d %b'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: date = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timeProcessH.running = true
            timeProcessM.running = true
            dateProcess.running = true
        }
    }

    //  FIRST START
    IpcHandler {
        target: "firstStart"

        function start() {
            //
            
        }
    }

    Connections {
        target: Quickshell

        function onReloadCompleted() {
            //console.log(myData.wallpaper)
            //let wpPath = "/home/hekkenok/.config/quickshell/theme/wallpapers/wallhaven-ex2yvo.png"
            //updateTheme(myData.wallpaper)

        }
    }
}