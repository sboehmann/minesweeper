import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Ctrl14
import "minesweeper.js" as Minesweeper

Window {
    id: window
    visible: true
    width: 680
    height: 480
    title: qsTr("Minesweeper")

    Image {
        id: background
        anchors.fill: parent
        asynchronous: true
        smooth: true
        source: "qrc:/bg.png"
    }

    ColumnLayout {
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
            Ctrl14.Button {
                id: resetButton
                text: "Reset"
                onClicked: {
                    Minesweeper.dimension = dimension.value
                    Minesweeper.mines = Minesweeper.initMinesweeper()
                    table.columns = Minesweeper.dimension
                    table.rows = Minesweeper.dimension
                    allButtons.model = 0
                    allButtons.model = Minesweeper.dimension * Minesweeper.dimension
                    numBombsNum.text = Minesweeper.mines.length
                }
            }
            Ctrl14.SpinBox {
                id: dimension
                minimumValue: 6
                maximumValue: 12
            }

            RowLayout{
                anchors.top: table.bottom
                anchors.right: table.right
                Timer {
                    id: gameTime
                    running: true // Warum funktionierte gameTime.start bei Component.onCompleted nicht?
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
                    id: gameTimeDisplay
                    font.pixelSize: 15
                    text: "noch nix"
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
}
