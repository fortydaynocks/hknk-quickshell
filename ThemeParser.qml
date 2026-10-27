pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: themeRoot

    property string themePath: Quickshell.shellPath("./theme/theme.json")

    FileView {
        id: themeJson
        path: themePath

        watchChanges: true
        blockLoading: true

        onFileChanged: this.reload()
    }

    readonly property var theme: JSON.parse(themeJson.text())

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
}