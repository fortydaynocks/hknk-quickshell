import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Bluetooth


RowLayout {
    id: root

    Repeater {
        model: Bluetooth.devices

        Rectangle {
            id: btLabel

            property var connected: modelData.connected
            property var battery_display: modelData.batteryAvailable ? modelData.battery * 100 + "% 󰁹" : ""

            implicitWidth: btText.implicitWidth + 8
            implicitHeight: barHeight

            color: connected ? color_bright : color_dark2

            Text {
                id: btText

                anchors.centerIn: parent

                font: normalFont
                color: connected ? color_bg : color_dark

                text: connected ? modelData.deviceName + " : " + battery_display : modelData.deviceName

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.OutCirc
                        duration: 200
                    }
                }
            }

            MouseArea{
                anchors.fill: parent

                hoverEnabled: true

                onClicked: function(mouse) {
                    if (modelData.paired) {
                        modelData.connected = !modelData.connected
                    }
                }

                onEntered: {
                    btLabel.opacity = 0.5

                }

                onExited: {
                    btLabel.opacity = 1

                }
            }

            Behavior on opacity {
                NumberAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCirc
                    duration: 200
                }
            }
        }
    }
}