import QtQuick 2.5
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQml.StateMachine 1.0 as SMF

import "minesweeper.js" as Minesweeper
import "."

Item {    
    property int position: 0

    property alias backgroundColor : background.color
    property alias border : background.border
    property alias font : text.font

    property real initialStateOpacity : 0.9
    property color initialStateColor : "white"

    property real flagStateOpacity : 0.8
    property color flagStateColor : "red"

    property real questionStateOpacity : 0.7
    property color questionStateColor : "blue"

    property real explodedStateOpacity : 0.6
    property color explodedStateColor : "darkred"

    QtObject {
        id: p;

        property bool isRightButton: true
        property bool isExplosive: Minesweeper.isExplosivePosition(position)
        property bool isCellForCascadeOpen: Minesweeper.isCellForCascadeOpen(position)
        property int explosiveSiblingCount: Minesweeper.explosiveSiblingCount(position)

        function siblingCountButtonTextColor()
        {
            switch(explosiveSiblingCount) {
            case 1:
                return "blue";
            case 2:
                return "green";
            case 3:
                return "red";
            case 4:
                return "purple";
            case 5:
                return "maroon";
            case 6:
                return "cyan";
            case 7:
                return "black";
            case 8:
                return "gray";
            default:
                break;
            }

            return "white";
        }
    }

    SMF.StateMachine {
        id: stateMachine
        initialState: startState
        running: true

        SMF.State {
            id: startState

            onEntered: {
                text.text = ""
                text.color = initialStateColor
                background.opacity = initialStateOpacity
            }

            SMF.SignalTransition {
                targetState: questionState
                signal: mousearea.onClicked
                guard: p.isRightButton
            }

            SMF.SignalTransition {
                targetState: explodeState
                signal: mousearea.onClicked
                guard: !p.isRightButton && p.isExplosive;
            }

            SMF.SignalTransition {
                targetState: finalState
                signal: mousearea.onClicked
                guard: !p.isRightButton && !p.isExplosive;
            }


            SMF.SignalTransition {
                targetState: finalState
                signal: jumpToFinalState
            }

            SMF.SignalTransition {
                targetState: explodeState
                signal: jumpToExplodeState
            }
        }

        SMF.State {
            id: questionState

            onEntered: {
                text.text = qsTr("?")
                text.color = questionStateColor
                background.opacity = questionStateOpacity
            }

            SMF.SignalTransition {
                targetState: flagState
                signal: mousearea.onClicked
                guard: p.isRightButton
            }
        }

        SMF.State {
            id: flagState

            onEntered: {
                text.text = qsTr("\u2691")
                text.color = flagStateColor
                background.opacity = flagStateOpacity
                flagsSet += 1
                if(p.isExplosive) {
                    minesFound += 1
                }
            }

            onExited: {
                flagsSet -= 1
                if(p.isExplosive) {
                    minesFound -= 1
                }
            }

            SMF.SignalTransition {
                targetState: startState
                signal: mousearea.onClicked
                guard: p.isRightButton
            }
        }

        SMF.State {
            id: explodeState

            SequentialAnimation {
                id: explodeStateAnimator

                ParallelAnimation {
                    ScaleAnimator {
                        target: text
                        from: 1.2
                        to: 0.8
                        easing.type: Easing.InBounce
                        duration: 400
                    }
                    RotationAnimator {
                        target: text
                        from: -15
                        to: 15
                        duration: 400
                    }
                }

                ParallelAnimation {
                    ScaleAnimator {
                        target: text
                        from: 0.8
                        to: 1.2
                        easing.type: Easing.OutBounce
                        duration: 400
                    }
                    RotationAnimator {
                        target: text
                        from: 15
                        to: -15
                        duration: 400
                    }
                }

                running: false
                loops: Animation.Infinite
            }

            onEntered: {
                text.text = qsTr("\uD83D\uDCA3")
                text.color = explodedStateColor
                background.opacity = explodedStateOpacity
                explodeStateAnimator.running = true
                GlobalData.isGameOver = true
            }
        }

        SMF.State {
            id: finalState

            onEntered: {
                text.text = p.explosiveSiblingCount
                text.visible = p.explosiveSiblingCount > 0
                text.color = p.siblingCountButtonTextColor()
                background.opacity = p.explosiveSiblingCount === 0 ? 0.25 : 0.5
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent

        color: "lightgray"
        border.color: "black"
        border.width: 1

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Text {
        id: text
        anchors.fill: parent
        font.pixelSize: height * 0.7
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        Behavior on color {
            ColorAnimation {
                duration: 1500
            }
        }
    }

    MouseArea {
        id: mousearea;
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons

        onClicked: {
            p.isRightButton = mouse.button == Qt.RightButton

            if(mouse.button === Qt.MiddleButton) {
                cascadeOpenCells(position)
            }
        }
    }

    signal cascadeOpenCells(int startPosition)
    signal jumpToFinalState()
    signal jumpToExplodeState()

    function openCell(posToOpen) {
        if (position !== posToOpen) return
        if (p.isExplosive) {
            jumpToExplodeState()
        } else {
            jumpToFinalState()
        }
    }

    ParallelAnimation {
        id: startupAnimation
        running: false

        NumberAnimation {
            target: background
            property: "rotation"

            from: 0
            to: 360
            easing.type: Easing.OutBounce
            duration: Minesweeper.randomInt(500, 4000)
        }

        ColorAnimation {
            target: background
            property: "color"

            from: Qt.rgba(Math.random(),Math.random(),Math.random(),1)
            to: backgroundColor
            duration: Minesweeper.randomInt(500, 4000)
        }
    }

//    Component.onCompleted: startupAnimation.start()
}
