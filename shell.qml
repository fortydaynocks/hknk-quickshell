
//@ pragma UseQApplication
// must remain commented. used for system tray functionality.

import Quickshell
import Quickshell.Io
import QtQuick

import qs.bar

Scope {
    id: root

    //  THEMING
    property var theme: Theme.theme
    
    property var normalFont: Theme.normalFont
    property var lightFont: Theme.normalFont
    property var smallFont: Theme.smallFont
    property var bigFont: Theme.bigFont
    
    //  OBJECTS
    Bar {}
}