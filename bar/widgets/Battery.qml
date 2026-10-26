import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts
import Quickshell.Widgets

import Quickshell.Services.UPower
RowLayout {
    id: root

    property int batteryDivision: 10
    property string batteryBar: ""
    property string batteryBarUnit: "󰝤"

    property var usedColor: batteryPercentage <= 0.2 ? theme.colors.critical : (batteryPercentage <= 0.2 ? theme.colors.critical : theme.colors.accent)

    spacing: padding
    Text {
        font: normalFont
        color: usedColor
        
        text: Math.round(batteryPercentage * 100) + "% ["
    }

    RowLayout {
        spacing: -1

        Repeater {
            model: maxBatteryPercentage / batteryDivision

            Text {
                property real assignedPercentage: ((index) * batteryDivision) / 100
                property real opacityMath: (batteryPercentage - assignedPercentage) * 10

                font: normalFont
                color: usedColor
                
                text: assignedPercentage <= Math.ceil(batteryPercentage) ? batteryBarUnit : " "
                opacity: opacityMath
            }
        }
        
    }

    Text {
        font: normalFont
        color: usedColor
        
        text: "]"
    }

    Text {
        font: normalFont
        color: battery.state == UPowerDeviceState.Charging ? theme.colors.accent2 : usedColor

        text: battery.state == UPowerDeviceState.Charging ? "󱐋 CHARGING" : "BTRY"
    }
}