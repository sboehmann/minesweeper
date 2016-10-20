import QtQuick 2.5
import QtQuick.Window 2.2

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
}
