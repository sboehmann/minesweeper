import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Dialog {
    visible: true
    title: "Pause"
    modality: Qt.WindowModal

    contentItem: Rectangle {
        color: "lightskyblue"
        implicitWidth: 400
        implicitHeight: 100
        Text {
            text: "Game is paused!"
            color: "navy"
            anchors.centerIn: parent
        }
    }
}
