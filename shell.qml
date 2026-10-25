
//@ pragma UseQApplication
// must remain commented. used for system tray functionality.

import Quickshell
import Quickshell.Io
import QtQuick

import Quickshell.Services.Mpris

import qs.bar
import qs.desktop

Scope {
    id: shellRoot

    //  THEMING
    property var theme: ThemeParser.theme
    
    property var normalFont: ThemeParser.normalFont
    property var lightFont: ThemeParser.normalFont
    property var smallFont: ThemeParser.smallFont
    property var bigFont: ThemeParser.bigFont

    //  MEDIA
    property var media: Mpris.players.values[Mpris.players.values.length - 1] || null
    property var mediaArtist: media ? media.trackArtist : "?"
    property var mediaTitle: media ? media.trackTitle : ""
    property var mediaArtPlaceholder: ""//Qt.resolvedUrl(Quickshell.shellPath("images/audio-placeholder.png"))
    property var mediaArt: media ? media.trackArtUrl : mediaArtPlaceholder
    property var mediaPlaying: media ? media.isPlaying : false
    
    
    //  OBJECTS
    Bar {}
    //Desktop {}

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
}