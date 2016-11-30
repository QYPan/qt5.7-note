import QtQuick 2.5
import "hanoi.js" as LogicCal

Rectangle {
    id: screen
    width: 1020
    height: 520
    Item {
        anchors.fill: parent
        Rectangle {
            id: background
            anchors.fill: parent
            color: "black"
        }
        Rectangle {
            id: pillar1
            x: (cover.rectWidth - width) / 2
            width: 20
            height: cover.rectHeight * (cover.row - 2)
            color: "gray"
            anchors.bottom: cover.bottom
        }
        Rectangle {
            id: pillar2
            x: (cover.rectWidth - width) / 2 + cover.rectWidth
            width: 20
            height: cover.rectHeight * (cover.row - 2)
            color: "gray"
            anchors.bottom: cover.bottom
        }
        Rectangle {
            id: pillar3
            x: (cover.rectWidth - width) / 2 + 2 * cover.rectWidth
            width: 20
            height: cover.rectHeight * (cover.row - 2)
            color: "gray"
            anchors.bottom: cover.bottom
        }
        Item {
            id: cover
            property int row: 13
            property int column: 3
            property real rectWidth: width / column
            property real rectHeight: height / row
            anchors.fill: parent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 30
            anchors.bottomMargin: 30
            //anchors {fill: parent; centerIn: parent; margins: 30}
            /*
            Rectangle { //点击范围
                anchors.fill: parent
                color: "red"
            }
            */
            MouseArea {
                anchors.fill: parent
                onClicked: LogicCal.handleClicked(mouse.x, mouse.y)
            }
        }
        Rectangle {
            id: ground
            width: cover.width
            height: 30
            anchors.top: cover.bottom
            color: "gray"
        }
    }
    Component.onCompleted: LogicCal.initTheDisc(5)
}
