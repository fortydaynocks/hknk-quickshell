import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Services.Pipewire

RowLayout {
    id: root

    anchors.centerIn: parent

    property int volumeValue: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
    property bool volumeMuted: Pipewire.defaultAudioSink.audio.muted

    property string netValue: "no network..."
    property string ramValue: ""
    property string diskValue: ""

    Text {
        font: normalFont
        color: theme.colors.accent2
        textFormat: Text.RichText
        text: !volumeMuted ? volumeValue + "% <font color=" + theme.colors.dark2 + ">VOL</font>"
        : " <font color=" + theme.colors.dark1 + ">AUDIO MUTED</font>"
    }

    Separator { text: "|"; color: theme.colors.dark2 }

    Battery { visible: shellRoot.battery }
    Separator { visible: shellRoot.battery; text: "|"; color: theme.colors.dark2 }

    Text {
        id: netLabel
        font: normalFont
        color: !(netValue == "no network...") ? theme.colors.accent2 : theme.colors.dark3
        textFormat: Text.RichText
        text: netValue + " <font color=" + theme.colors.dark2 + ">NET</font>"
    }

    Separator { text: "|"; color: theme.colors.dark2 }

    Text {
        id: ramLabel
        font: normalFont
        color: theme.colors.accent
        textFormat: Text.RichText
        text: ramValue + " <font color=" + theme.colors.dark2 + ">RAM</font>"
    }

    Separator { text: "|"; color: theme.colors.dark2 }

    Text {
        id: diskLabel
        font: normalFont
        color: theme.colors.accent

        textFormat: Text.RichText
        text: diskValue + " <font color=" + theme.colors.dark2 + ">DISK</font>"
    }
















    Process {
        id: netProcess

        command: ["bash", "-c", "nmcli device show | awk 'NR==6 {print $2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() == "lo") {
                    netValue = "no network..."
                } else {
                    netValue = text.trim()
                }
            }
        }
    }

    Process {
        id: ramProcess

        command: ["bash", "-c", "free -h --si | awk '/^Mem:/ {print $7}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: ramValue = text.trim()
        }
    }

    Process {
        id: diskProcess

        command: ["bash", "-c", "df -h | awk 'NR==2 {print $4}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: diskValue = text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            netProcess.running = true
            ramProcess.running = true
            diskProcess.running = true
        }
    }

    //  ----- IMPORTANT FOR VOLUME DETECTION!
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}