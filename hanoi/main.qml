import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "hanoi.js" as LOGIC_CAL

Rectangle {
    id: root
    width: 960
    height: 600
    color: "black"
    Text {
        id: gameName
        text: "Tower of Hanoi"
        font.bold: true
        font.pixelSize: 45
        color: Qt.lighter("green")
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Item {
        width: 70
        height: 80
        z: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        Image {
            source: "images/arrow.png"
            anchors.fill: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(beginButton.visible){
                    Qt.quit();
                }else{
                    LOGIC_CAL.clearAllDiscs();
                    choseLevel.visible = false;
                    if(msgDialog.visible){
                        msgDialog.visible = false;
                        touchArea.enabled = true;
                    }
                    screen.visible = false;
                    beginButton.visible = true;
                }
            }
        }
    }

    Column {
        id: beginButton
        anchors.centerIn: parent
        z: 25
        Button {
            id: youDoButton
            //text: "next"
            style: ButtonStyle {
                background: Rectangle {
                    color: "#afda33"
                    implicitWidth: 180
                    implicitHeight: 90
                    border.color: (control.hovered || control.pressed)
                                    ? "#987323" : "#678856"
                    border.width: control.pressed ? 3 : 1
                    Text {
                        text: "You Do"
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: 40
                    }
                }
            }
            onClicked: {
                beginButton.visible = false;
                screen.visible = true;
                gameMap.discCount = 3;
                touchArea.enabled = true;
                LOGIC_CAL.initDiscsPos(gameMap.discCount, 0);
            }
        }
        Button {
            id: itDoButton
            //text: "next"
            style: ButtonStyle {
                background: Rectangle {
                    color: "#afda33"
                    implicitWidth: 180
                    implicitHeight: 90
                    border.color: (control.hovered || control.pressed)
                                    ? "#987323" : "#678856"
                    border.width: control.pressed ? 3 : 1
                    Text {
                        text: "It Do"
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: 40
                    }
                }
            }
            onClicked: {
                beginButton.visible = false;
                choseLevel.visible = true;
                touchArea.enabled = false;
            }
        }
    }
    ChoseLevel {
        id: choseLevel
        visible: false
        anchors.fill: parent
        anchors.margins: 30
        onChoseClicked: {
            screen.visible = true;
            LOGIC_CAL.initDiscsPos(level, 1);
            choseLevel.visible = false;
        }
    }
    Rectangle {
        id: screen
        visible: false
        width: parent.width
        height: parent.height - gameName.height
        color: "black"
        anchors.top: gameName.bottom
        anchors.topMargin: 10
        Item {
            id: gameMap
            anchors.fill: parent
            anchors.centerIn: parent
            anchors.margins: 30
            property int discCount: 3
            //color: "blue"
            Rectangle {
                id: ground
                width: parent.width
                height: 50
                anchors.bottom: parent.bottom
                color: "gray"
                radius: 3
            }
            Rectangle {
                id: pillar1
                x: (touchArea.rectWidth - width) / 2
                width: 30
                height: (touchArea.rectRow - 2) * touchArea.rectHeight
                color: "gray"
                anchors.bottom: ground.top
            }
            Rectangle {
                id: pillar2
                x: pillar1.x + touchArea.rectWidth
                width: 30
                height: (touchArea.rectRow - 2) * touchArea.rectHeight
                color: "gray"
                anchors.bottom: ground.top
            }
            Rectangle {
                id: pillar3
                x: pillar2.x + touchArea.rectWidth
                width: 30
                height: (touchArea.rectRow - 2) * touchArea.rectHeight
                color: "gray"
                anchors.bottom: ground.top
            }
            MsgDialog {
                id: msgDialog
                anchors.centerIn: parent
                visible: false
                z: 20
                onClearDisc: {
                    LOGIC_CAL.clearAllDiscs();
                    gameMap.discCount += 1;
                    touchArea.enabled = true;
                    LOGIC_CAL.initDiscsPos(gameMap.discCount, 0);
                    msgDialog.visible = false;
                }
            }
            Item {
                id: touchArea
                //anchors.fill: parent
                anchors.bottom: ground.top
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                property int rectRow: 13
                property int rectColumn: 3
                property real rectWidth: width / rectColumn
                property real rectHeight: height / rectRow
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        LOGIC_CAL.handleClicked(mouse.x, mouse.y);
                    }
                }
            }
        }
    }
}
