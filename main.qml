import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as Cntrls
import QtQuick.Layouts 1.1

import "minesweeper.js" as Minesweeper

Cntrls.ApplicationWindow {
    id: window
    visible: true
    width: 680
    height: 500
    title: qsTr("Minesweeper")

    menuBar: Cntrls.MenuBar {
        Cntrls.Menu {
            title: "Controls"
            Cntrls.MenuItem {
                text: "Restart"
                onTriggered: {
                    mineField.model = 0;
                    mineField.model = Minesweeper.dimension * Minesweeper.dimension;
                    Minesweeper.setMines();
                    gameTimer.timestamp = 0;
                    minesFoundLabel.text = "Mines Found: " + Minesweeper.getNumberOfMines();
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
                width: Math.max(16, (Math.min(window.width, window.height) / table.columns) - 8)
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
                onTriggered: { timestamp += 1; time.text = "Time: " + timestamp + " sec."}
            }

            Text {id: time}
            Cntrls.Label {
                id: minesFoundLabel
                text: "Mines Found: " + Minesweeper.getNumberOfMines()
            }
        }
    }
}
