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
            rows: columns
            anchors.centerIn: parent

            Repeater {
                model: table.rows *  table.columns

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
        }
    }
}
