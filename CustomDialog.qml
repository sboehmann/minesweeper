import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Dialog {
    id: pauseDialog
    visible: true
    title: "Pause"
    modality: Qt.ApplicationModal
    width: 100
    height: 100

    Text {
        anchors.centerIn: parent
        text: qsTr("Game is paused!")
    }
}
