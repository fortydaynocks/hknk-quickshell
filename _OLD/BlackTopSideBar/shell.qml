//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick

import qs.bar
//import qs.cava

Scope {
    id: root

    //  THEMING
    property var theme: Theme.theme
    
    property var normalFont: Theme.normalFont
    property var lightFont: Theme.normalFont
    property var smallFont: Theme.smallFont
    property var bigFont: Theme.bigFont
    
    //  GUESS WHAT THIS DOES...
    Bar {}
    //CavaVis {}
}
