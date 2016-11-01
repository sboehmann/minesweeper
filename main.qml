import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

import "minesweeper.js" as Minesweeper

Window {
    id: window
    visible: true
    width: 680
    height: 480
    title: qsTr("Minesweeper")

    QtObject {
        id: p
        property bool revealing: false

        function restartGame() {
            stopclock.running = false;
            tableLoader.active = false;
            Minesweeper.resetMines();
            tableLoader.active = true;
            updateBombCounter();
        }

        function setDimension(dimension) {
            Minesweeper.setDimension(dimension);
            restartGame();
        }

        function updateBombCounter() {
            bombCounter.text = Minesweeper.bombsLeft();
        }

        function addBombMark() {
            Minesweeper.addBombMark();
            updateBombCounter();
        }

        function removeBombMark() {
            Minesweeper.removeBombMark()
            updateBombCounter();
        }

        function revealSafeNeighbors(position, grid) {
            if (revealing) {
                return;
            }
            revealing = true;

            var neighbors = Minesweeper.safeNeighborhood(position)
            console.log("revealSafeNeighbors: " + position + " - neighbors: " + neighbors);

            for (var i = 0; i < neighbors.length; ++i) {
                grid.itemAt(neighbors[i]).revealed()
            }

            revealing = false;
        }
    }

    Image {
        id: background
        anchors.fill: parent
        asynchronous: true
        smooth: true
        source: "qrc:/bg.png"
    }

    RowLayout {

        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        ColumnLayout {
            width: 100
            Layout.fillWidth: false
            spacing: 5

            Button {
                Layout.fillWidth: true
                text: "Restart"
                onClicked: p.restartGame()
            }

            ComboBox {
                Layout.fillWidth: true
                model: [ "8x8", "16x16", "24x24", "32x32" ]
                onCurrentIndexChanged: p.setDimension(8 * (currentIndex+1))
            }

            Item {
                Layout.fillHeight: true
            }

            BombCounter {
                id: bombCounter
                Layout.fillWidth: true
            }

            Clock {
                id: stopclock
                Layout.fillWidth: true
            }

        }

        Component {
            id: tableComponent

            Grid {
                id: table
                columns: Minesweeper.dimension
                rows: columns

                Repeater {
                    id: tableRepeater
                    model: table.rows * table.columns

                    Tile {
                        width: Math.max(16, (Math.min(parent.width, parent.height) / table.columns) - 8)
                        height: width
                        position: modelData

                        onClicked: stopclock.running = true;
                        onNoBombsNearby: p.revealSafeNeighbors(position, tableRepeater);
                        onMarkedAsBomb: p.addBombMark()
                        onUnmarkedAsBomb: p.removeBombMark()
                    }
                }
            }
        }

        Loader {
            id: tableLoader
            sourceComponent: tableComponent
            active: false

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        p.restartGame();
    }
}
