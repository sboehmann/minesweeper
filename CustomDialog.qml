import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0

Rectangle {
    id: dialogBox
    opacity: 0.7
    Text {
        id: dialogMsg
        font.pixelSize: 26
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mouse.accepted = true
        }
    }

    states: [
        State {
            name: "default"
        },
        State {
          name: "pause"
          PropertyChanges {
              target: dialogMsg
              color: "white"
              text: qsTr("Pause!")
          }
          PropertyChanges {
              target: dialogBox
              color: "blue"
          }
        },
        State {
          name: "gameover"
          PropertyChanges {
              target: dialogMsg
              color: "white"
              text: qsTr("Game Over!")
          }
          PropertyChanges {
              target: dialogBox
              color: "red"
          }
        },
        State {
          name: "win"
          PropertyChanges {
              target: dialogMsg
              color: "white"
              text: qsTr("You win!")
          }
          PropertyChanges {
              target: dialogBox
              color: "green"
          }
        }


    ]
}
