//@ pragma UseQApplication

import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text

import qs.bar

Scope {
    id: root

    //  THEMING
    property color color_bg: "#111111"

    property color color_bright: '#c0c0c0'
    property color color_bright2: '#a0a0a0'
    property color color_bright3: '#808080'

    property color color_dark: "#191919"
    property color color_dark2: "#444444"
    property color color_dark3: "#666666"

    property color urgent_red: '#ff4f4f'

    property string fontFamily: "JetBrainsMono Nerd Fonts Propo"

    property var normalFont: Qt.font({
        family: "JetBrainsMono Nerd Fonts Propo",
        bold: true,
        pointSize: 10
    })

    //  GUESS WHAT THIS DOES...
    Bar {}
}
