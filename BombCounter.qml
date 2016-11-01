import QtQuick 2.5
import QtQuick.Layouts 1.1

Rectangle {
    property alias text: textitem.text

    Layout.fillWidth: true
    implicitHeight: textitem.height

    color: "white"
    antialiasing: true

    Text {
        font.pixelSize: 20
        text: "Bombs:"
    }

    Text {
        id: textitem
        width: parent.width
        font.pixelSize: 20
        horizontalAlignment: Text.AlignRight
        text: "-"
    }
}
