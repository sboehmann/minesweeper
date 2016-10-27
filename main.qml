import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as Cntrls
import QtQuick.Layouts 1.1

import "minesweeper.js" as Minesweeper
import "."

Cntrls.ApplicationWindow {
    id: mainWindow
    visible: true
    width: 680
    height: 500
    title: qsTr("Minesweeper")

    property int minesFound: 0
    property bool isGameOver: GlobalData.isGameOver
    property string minesFoundText: qsTr("Mines Found: ")
    property string minesExistText: qsTr("Mines Exist: ")

    onMinesFoundChanged: {
        minesFoundLabel.text = minesFoundText + minesFound
    }

    onIsGameOverChanged: {
        if(isGameOver) {
            gameTimer.stop()
            customDialog.state = "gameover"
            customDialog.visible = true
        }
    }

    menuBar: Cntrls.MenuBar {
        Cntrls.Menu {
            title: "Controls"
            Cntrls.MenuItem {
                text: "Restart"
                onTriggered: {
                    // hide custom dialog, in case of game over
                    customDialog.state = "default"
                    customDialog.visible = false

                    // redraw mineField
                    mineField.model = 0;
                    mineField.model = Minesweeper.dimension * Minesweeper.dimension;

                    // reset minefield
                    minesFound = 0;
                    Minesweeper.setMines();

                    GlobalData.isGameOver = false;
                    gameTimer.timestamp = 0;
                    minesExistLabel.text = minesExistText + Minesweeper.getNumberOfMines();
                }
            }

            Cntrls.MenuItem {
                text: "Pause"
                shortcut: "Space"
                onTriggered: {
                    if(customDialog.state === "gameover") return
                    customDialog.state = "pause"
                    customDialog.visible = !customDialog.visible
                    if(customDialog.visible) {
                        gameTimer.stop()
                    } else {
                        gameTimer.start()
                    }

                }
            }

            Cntrls.MenuItem {
                text: "Quit"
                shortcut: "Ctrl+Q"
                onTriggered: { Qt.quit() }
            }
        }

    }

    Image {
        id: background
        anchors.fill: parent
        asynchronous: true
        smooth: true
        source: "qrc:/bg.png"
    }

    Grid {
        id: table
        columns: Minesweeper.dimension
        rows: columns
        anchors.centerIn: parent

        Repeater {
            id: mineField
            model: table.rows *  table.columns

            Button {
                id: mineCell
                width: Math.max(16, (Math.min(mainWindow.width, mainWindow.height) / table.columns) - 8)
                height: width
                position: modelData
            }
        }
    }

    statusBar: Cntrls.StatusBar {
        RowLayout {
            anchors.fill: parent
            Timer {
                id: gameTimer
                property int timestamp: 0
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    timestamp += 1
                    time.text = qsTr("Time: ") + timestamp + qsTr(" sec.")
                }
            }

            Text {id: time}
            Cntrls.Label {
                id: minesExistLabel
                text: minesExistText + Minesweeper.getNumberOfMines()
            }
            Cntrls.Label {
                id: minesFoundLabel
                text: minesFoundText + "0"
            }
        }
    }

    CustomDialog {
        id: customDialog
        visible: false
        anchors.fill: parent
    }
}
