
//@ pragma UseQApplication
// must remain commented. used for system tray functionality.

import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Hyprland

import qs.bar
import qs.desktop


Scope {
    id: shellRoot

    // PATHS
    property var themePath: Quickshell.shellPath("data/theme.json")
    property var themesPath: Qt.resolvedUrl("theme/themes")
    property var dataPath: Quickshell.shellPath("data/myData.json")

    //  THEMING
    property var theme: ThemeParser.theme
    
    property var normalFont: ThemeParser.normalFont
    property var lightFont: ThemeParser.normalFont
    property var smallFont: ThemeParser.smallFont
    property var bigFont: ThemeParser.bigFont

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
            property string chosenTheme: ""
            property int chosenThemeIndex: 0
        }
    }

    //  THEME SWITCHING
    function trimmedColor(color) {
       
    }

    function cmd(doThis) {
        Quickshell.execDetached( { command: ["sh", "-c", doThis] } )
    }

    function configEdit(configPath, parameter,  denominator = "=", value, mode = "fuzzelColor") {
        if (!configPath) { return }

        let patchedValue = value

        if (mode == "fuzzelColor") {
            patchedValue = patchedValue.replace("#", "")
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

        Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/" + parameter + denominator + ".*/" + parameter + denominator + patchedValue + "/' " + configPath] } )
    }

    function updateTheme(themeUrl, themeData) {
        dataJson.adapter.chosenTheme = themeUrl
        let cleanedUrl = themeUrl.replace("file://", "")

        Quickshell.execDetached( { command: ["sh", "-c", "cp " + cleanedUrl + " " + themePath] } )  //  OVERWRITES THEME FILE 
        ThemeParser.updatePath(cleanedUrl)  //  REREADS THEME FILE
        Quickshell.execDetached( { command: ["sh", "-c", "wpaperd & wpaperctl set " + themeData.wallpaper] } )  //  UPDATES WPAPERD
        Quickshell.execDetached( { command: ["sh", "-c", "hyprctl reload"] } )  //  UPDATES HYPRLAND
        
        //  KITTY
        configEdit("~/.config/kitty/kitty.conf", "background", " ", themeData.colors.bg, "kittyColor")
        configEdit("~/.config/kitty/kitty.conf", "foreground", " ", themeData.colors.dark3, "kittyColor")

        //  FUZZEL
        configEdit("~/.config/fuzzel/fuzzel.ini", "background", "=", themeData.colors.bg, "fuzzelColor")
        configEdit("~/.config/fuzzel/fuzzel.ini", "border", "=", themeData.colors.stroke, "fuzzelColor")
        configEdit("~/.config/fuzzel/fuzzel.ini", "text", "=", themeData.colors.dark3, "fuzzelColor")
        configEdit("~/.config/fuzzel/fuzzel.ini", "selection", "=", themeData.colors.accent, "fuzzelColor")
        configEdit("~/.config/fuzzel/fuzzel.ini", "selection-text", "=", themeData.colors.bg, "fuzzelColor")
        configEdit("~/.config/fuzzel/fuzzel.ini", "selection-match", "=", themeData.colors.stroke, "fuzzelColor")

        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/background=.*/background=" + fuzzelColor(themeData.colors.bg) + "/' ~/.config/fuzzel/fuzzel.ini"] } )
        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/border=.*/border=" + fuzzelColor(themeData.colors.stroke) + "/' ~/.config/fuzzel/fuzzel.ini"] } )
        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/text=.*/text=" + fuzzelColor(themeData.colors.dark3) + "/' ~/.config/fuzzel/fuzzel.ini"] } )

        //Quickshell.execDetached( { command: ["sh", "-c", "sed -i 's/selection=.*/selection=" + fuzzelColor(themeData.colors.dark3) + "/' ~/.config/fuzzel/fuzzel.ini"] } )

        //cmd("kitten @ set-colors background=" + trimmedColor(themeData.colors.background))
        //cmd("kitten @ set-colors foreground=" + trimmedColor(themeData.colors.dark3))
        Quickshell.reload(false)
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
            updateTheme(dataJson.adapter.chosenTheme, ThemeParser.theme)
            
        }
    }
}