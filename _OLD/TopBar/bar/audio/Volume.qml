import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

import Quickshell.Services.Pipewire

Rectangle {
    id: rec

    property int volume_value: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
    property bool volume_muted: Pipewire.defaultAudioSink.audio.muted

    implicitWidth: volume.implicitWidth + 20
    implicitHeight: barHeight

    color: volume_muted ? color_dark : color_bright

    Text {
        id: volume
        anchors.centerIn: parent

        color: volume_muted ? color_bright3 : color_dark
        font: normalFont
        text: volume_muted ? "  MUTED" : "  " + (rec.volume_value ?? 0) + "%"

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.OutCirc
                duration: 300
            }
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
                rec.opacity = 0.5

            }

            onExited: {
                rec.opacity = 1

            }
        }
    }

     //  -----   -----
    Behavior on implicitWidth {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 300
        }
    }

     Behavior on color {
        ColorAnimation {
            easing.type: Easing.OutCirc
            duration: 300
        }
    }

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.OutCirc
            duration: 200
        }
    }

    //  ----- IMPORTANT FOR VOLUME DETECTION!
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    
    Rectangle {
        id: tray

        x: rec.width

        width: 0
        height: barHeight

        color: color_bright
    }

    onVolume_valueChanged: {
    }
}