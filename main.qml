import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Ctrl14
import QtQuick.Dialogs 1.2
import "minesweeper.js" as Minesweeper

Window {
    id: window
    visible: true
    width: 500 // todo
    height: 680 // todo
    title: qsTr("Minesweeper")

    Dialog  {
        id: lostDialog
        visible: false
        title: "oops"

        contentItem: Rectangle {
            Text {
                text: "Kawumm! Verloren."
                font.pixelSize: 15
            }
            implicitHeight: 50
        }
        onVisibilityChanged: {
            timerArea.gameRunning = false
        }
    }

    Image {
        id: background
        anchors.fill: parent
        asynchronous: true
        smooth: true
        source: "qrc:/bg.png"
    }

    ColumnLayout {
        id: mainLayout
        anchors.top: parent.top
        anchors.left: parent.left
        Grid {            
            id: table
            columns: Minesweeper.dimension
            rows: Minesweeper.dimension
            anchors.centerIn: parent

            Repeater {
                id: allButtons
                model: Minesweeper.dimension *  Minesweeper.dimension
                Button {
                    width: Math.max(16, (Math.min(window.width, window.height) / table.columns) - 8)
                    height: width
                    position: modelData
                    Component.onCompleted: {
                        lost.connect(lostDialog.open)
                    }
                }
            }
        }

        RowLayout {
            id: infoBar
            anchors.top: table.bottom

            Ctrl14.Label {
                id: numBombsLabel
                text: "Anzahl Minen:"
                font.pixelSize: 15
                color: "white"
            }
            Ctrl14.Label {
                id: numBombsNum
                text: Minesweeper.mines.length
                font.pixelSize: 15
                color: "white"
            }
        }
        RowLayout {
            id: resizeReset
            anchors.top: infoBar.bottom
            anchors.margins: 10
            Ctrl14.Label {
                text: "Feldgröße (quadr.):"
                font.pixelSize: 15
                color: "white"
            }

            Ctrl14.SpinBox {
                id: dimension
                value: Minesweeper.dimension
                minimumValue: 6
                maximumValue: 12
            }

            Ctrl14.Button {
                id: resetButton
                text: "Reset"
                onClicked: {
                    timerArea.gameDuration = 0
                    Minesweeper.dimension = dimension.value
                    Minesweeper.mines = Minesweeper.initMinesweeper()
                    table.columns = Minesweeper.dimension
                    table.rows = Minesweeper.dimension
                    allButtons.model = 0
                    allButtons.model = Minesweeper.dimension * Minesweeper.dimension
                    numBombsNum.text = Minesweeper.mines.length
                    timerArea.gameRunning = true
                }
            }
        }

        RowLayout{
            anchors.top: resizeReset.bottom
            anchors.margins: 10
            id: timerArea
            property alias gameRunning: gameTime.running
            property alias gameDuration: gameTime.duration
            Timer {
                id: gameTime
                running: true
                interval: 1000
                repeat: true
                property int duration: 0
                onTriggered: {
                    if(running){
                        duration++
                        gameTimeDisplay.text = duration + " s";
                    }
                }
            }
            Ctrl14.Label {
                font.pixelSize: 15
                text: "Spieldauer:"
                color: "yellow"
            }
            Ctrl14.Label {
                // wäre schön, wenn dessen Größe nicht springen würde
                id: gameTimeDisplay
                font.pixelSize: 15
                text: "0 s"
                color: "yellow"
            }
            Ctrl14.Button {
                id: pauseBtn
                text: "Sleep"
                onClicked: {
                    // das kann nicht richtig sein, denn start/stop geht wegen Threadgrenzen nicht...
                    gameTime.running = !gameTime.running
                }
            }
        }
    }    
}
