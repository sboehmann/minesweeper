pragma Singleton
import QtQuick 2.0

QtObject {
    property bool isGameOver: false
    property bool isRedrawMinefield: false

    property int minesFound: 0
    property int flagsSet: 0
    property int dimensions
}
