pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: themeRoot

    FileView {
        id: themeJson
        path: Qt.resolvedUrl("./theme.json")

        watchChanges: true
        blockLoading: true

        onFileChanged: this.reload()
    }

    readonly property var theme: JSON.parse(themeJson.text())

    property var normalFont: Qt.font({
        family: theme.fontFamily,
        bold: theme.fontBold,
        pointSize: theme.fontSize
    })

    property var bigFont: Qt.font({
        family: theme.fontFamily,
        bold: theme.fontBold,
        pointSize: theme.fontSize + 4
    })

    property var lightFont: Qt.font({
        family: theme.fontFamily,
        bold: false,
        pointSize: theme.fontSize
    })

    property var smallFont: Qt.font({
        family: theme.fontFamily,
        bold: theme.fontBold,
        pointSize: theme.fontSize - 2
    })
}