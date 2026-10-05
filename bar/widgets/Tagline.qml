import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 8

    FileView {
        id: jason
        path: Qt.resolvedUrl("../../taglines.json")

        watchChanges: true
        blockLoading: true

        onFileChanged: this.reload()
    }

    readonly property var taglines: JSON.parse(jason.text())
    property string tagline: taglines[Math.floor(Math.random() * taglines.length)].toUpperCase()
    property string tagtext: tagline

    property int visible_chars: tagtext.length

    Text {
        font: normalFont
        color: theme.colorBright
        
        text: "HKNK"
    }

    Text {
      

        id: tagLabel

        font: normalFont
        color: theme.colorDark2
        
        text: tagtext.substring(0, visible_chars)
    }

    SequentialAnimation {
        id: typer

        NumberAnimation {
             id: type1

            target: root
            property: "visible_chars"
            
            from: tagtext.length
            to: 0

            duration: 800
           // easing.type: Easing.InExpo
        }

        //PauseAnimation { duration: 800 }

        ScriptAction {
           script: {
            changeText()
            type2.start()
           }
        }
    }

    NumberAnimation {
        id: type2

        target: root
        property: "visible_chars"
        
        from: 0
        to: tagtext.length

        duration: 800
        //easing.type: Easing.OutExpo
    }

    function changeText() {
        tagline = taglines[Math.floor(Math.random() * taglines.length)].toUpperCase()
        tagtext = tagline
    }
    
   
    Timer {
        interval: 60000
        running: true
        repeat: true

        onTriggered: {
            typer.start()
        }
    }
}


