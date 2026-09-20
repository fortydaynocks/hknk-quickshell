pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    //property string time

    //Process {
       // id: dateProcess

       // command: ["date", "+%H:%M"]
        //running: true

       // stdout: StdioCollector {
            //onStreamFinished: root.time = text
        //}
   // }

   // Timer {
        //id: dateTimer

        //interval: 1000
        //running: true
        //repeat: true

        //onTriggered: dateProcess.running = true
   // }

    property string time: {
        Qt.formatDateTime(clock.date, "hh:mm AP")
    }

    property string second: {
        Qt.formatDateTime(clock.date, "ss")
    }
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        
    }
}