import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as Cntrls
import QtQuick.Layouts 1.1

import "minesweeper.js" as Minesweeper

Cntrls.ApplicationWindow {
    id: mainWindow
    visible: true
    width: 680
    height: 500
    title: qsTr("Minesweeper")

    property int minesFound: 0
    property string minesFoundText: qsTr("Mines Found: ")
    property string minesExistText: qsTr("Mines Exist: ")

    onMinesFoundChanged: {
        minesFoundLabel.text = minesFoundText + minesFound
    }

    Loader {
        id: pauseDialogLoader
        source: "PauseDialog.qml"
        active: false
    }

    Connections {
        target: pauseDialogLoader.item
        onAccepted: {
            gameTimer.start()
            pauseDialogLoader.active = false
        }
    }

    menuBar: Cntrls.MenuBar {
        Cntrls.Menu {
            title: "Controls"
            Cntrls.MenuItem {
                text: "Restart"
                onTriggered: {
                    // redraw mineField
                    mineField.model = 0;
                    mineField.model = Minesweeper.dimension * Minesweeper.dimension;

                    // reset minefield
                    minesFound = 0;
                    Minesweeper.setMines();

                    gameTimer.timestamp = 0;
                    minesExistLabel.text = minesExistText + Minesweeper.getNumberOfMines();
                }
            }

            Cntrls.MenuItem {
                text: "Pause"
                shortcut: "Space"
                onTriggered: {
                    gameTimer.stop()
                    pauseDialogLoader.active = true
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
}
