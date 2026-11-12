pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: themeRoot

    property string themePath: Quickshell.shellPath("./data/theme.json")
    property string hellwalPath: Quickshell.shellPath("./theme/hellwalColors.json")
    property var wallpapers: Quickshell.shellPath("./theme/wallpapers")

    FileView {
        id: hellwalJson
        path: hellwalPath

        readonly property var json: JSON.parse(hellwalJson.text())

        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        adapter: JsonAdapter {}
    }

    FileView {
        id: themeJson
        path: themePath

        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        adapter: JsonAdapter {
            property string name: ""
            property string wallpaper: ""
            property string menuIcon: ""
            property int strokeWidth: 2
            property real bg_transparency: 0.8

            property var colors: {
                "bg": Qt.alpha(hellwalJson.json.colors.color0, bg_transparency),
                "stroke": hellwalJson.json.colors.color11,
                
                "dark1": hellwalJson.json.colors.color1, 
                "dark2": hellwalJson.json.colors.color10,
                "dark3": hellwalJson.json.colors.color12,

                "accent": hellwalJson.json.colors.color14,
                "accent2": hellwalJson.json.colors.color15,
                "accentdark": hellwalJson.json.colors.color6,

                "white": "#ffffff",
                "black": "#000000",
                "transparent": "#00000000",
                "critical": "#ff0000",
            }

            property var font: {
                "family": "JetBrainsMono Nerd Font Propo",
                "bold": true,
                "size": 10
            }

            property var fontSmall: {
                "family": "JetBrainsMono Nerd Font Propo",
                "bold": true,
                "size": 6
            }
        }
    }

    //  HELLWAL    

    //readonly property var themeColors: {
        //"bg": hellwalJson.adapter.colors.color0,
        //"stroke": hellwalJson.adapter.colors.color11,

        //"dark1": hellwalJson.adapter.colors.color1,
        //"dark2": hellwalJson.adapter.colors.color2,
        //"dark3": hellwalJson.adapter.colors.color3,

        //"accent": hellwalJson.adapter.colors.color7,
        //"accent2": hellwalJson.adapter.colors.color15,
        //"accentdark": hellwalJson.adapter.colors.color6,

        //"white": "#ffffff",
        //"black": "#000000",
        //"transparent": "#00000000",
        //"critical": "#ff0000"
    //} 

    property var theme: themeJson.adapter

    property var normalFont: Qt.font({
        family: theme.font.family,
        bold: theme.font.bold,
        pointSize: theme.font.size
    })
    property var smallFont: Qt.font({
        family: theme.fontSmall.family,
        bold: theme.fontSmall.bold,
        pointSize: theme.fontSmall.size
    })
    property var bigFont: Qt.font({
        family: theme.font.family,
        bold: theme.font.bold,
        pointSize: theme.font.size + 4
    })
    
    //
    function updatePath(path) { themeJson.path = path }


    //
    Process {
        id: hellwalProcess

        property string img: ""
        
        command: ["sh", "-c", "hellwal -i " + img + " -j > " + hellwalPath]
    }
    function doHellwal(img) {
        hellwalProcess.img = img
        hellwalProcess.running = true

    }
}