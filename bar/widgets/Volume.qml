import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

import Quickshell.Services.Pipewire

Rectangle {
    id: root

    property int volumeValue: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
    property bool volumeMuted: Pipewire.defaultAudioSink.audio.muted

    implicitWidth: label.width + padding
    implicitHeight: barSize * 0.5

    color: !volumeMuted ? theme.colors.accent : theme.colors.dark1

    Text {
        id: label
        anchors.centerIn: parent

        font: normalFont
        color: !volumeMuted ? theme.colors.dark1 : theme.colors.dark3
        
        text: volumeMuted ? " MUTED" : " " + (volumeValue ?? 0)
    }

    MouseArea {
        id: volumeScroll
        anchors.fill: parent

        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button == Qt.LeftButton) {
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
            }
        }

        onWheel: function(wheel) {
            if (!Pipewire.defaultAudioSink.audio.muted) {
                var dist = wheel.angleDelta.y / 2400
                Pipewire.defaultAudioSink.audio.volume += dist
            }
        }

        onEntered: {
            root.opacity = 0.5

        }

        onExited: {
            root.opacity = 1

        }
    }

    //  ----- IMPORTANT FOR VOLUME DETECTION!
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}