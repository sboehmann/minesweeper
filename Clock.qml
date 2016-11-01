import QtQuick 2.5
import QtQuick.Layouts 1.1

Rectangle {
    Layout.fillWidth: true
    implicitHeight: textitem.height

    color: "white"
    antialiasing: true

    property alias running: timer.running
    property date startDate: new Date()
    property date date: new Date()

    Timer {
        id : timer
        interval: 200
        running: false
        repeat: true

        onRunningChanged: {
            if (running) {
                startDate = new Date
                date = new Date
                console.log("Clock running")
            }
        }

        onTriggered: date = new Date
    }

    Text {
        font.pixelSize: 20
        text: "Time:"
    }

    Text {
        id: textitem
        width: parent.width
        font.pixelSize: 20
        horizontalAlignment: Text.AlignRight
        text: Math.floor((date-startDate) / 1000) + " s"
    }
}
