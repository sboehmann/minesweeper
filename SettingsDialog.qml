import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

import "minesweeper.js" as Minesweeper

Rectangle {
    id: settingsDialogBox
    opacity: 0.7

    MouseArea {
        transformOrigin: Item.Center
        anchors.fill: parent
        propagateComposedEvents: false
    }

    Grid{
        columns: 2
        rows: 3
        spacing: 2
        anchors.centerIn: parent
        Text {
            text: "Set dimension:"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            font.pixelSize: 24
        }

        TextField {
            id: dimensionInput
            width: 50
            text: Minesweeper.dimension
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            font.pixelSize: 24
            style: TextFieldStyle {
                textColor: "black"
                background: Rectangle {
                    radius: 2
                    border.color: "#333"
                    border.width: 1
                }
            }
        }

        Text {
            text: "Number of mines:"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            font.pixelSize: 24
        }

        TextField {
            id: minesInput
            width: 50
            text: Minesweeper.numberOfMines
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop
            font.pixelSize: 24
            style: TextFieldStyle {
                textColor: "black"
                background: Rectangle {
                    radius: 2
                    border.color: "#333"
                    border.width: 1
                }
            }
        }

        Button {
            id: acceptButton
            width: 50
            height: 50
            Text {
                text: qsTr("Ok")
                font.pixelSize: 24
                anchors.centerIn: parent
            }
            onClicked: {
                var dim = parseInt(dimensionInput.text)
                var mns = parseInt(minesInput.text)

                if (dim < 0 || mns <= 0) {
                    return
                }

                if (mns < (dim * dim / 2)) {
                    Minesweeper.dimension = dim
                    Minesweeper.numberOfMines = mns
                    settingsDialogBox.visible = false
                    mainWindow.restartGame()
                }
            }

        }

    }

}
