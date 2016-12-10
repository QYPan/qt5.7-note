import QtQuick 2.5
import "logic.js" as LOGIC_CAL
//import ComputerGo 1.0

Item {
    id: root
    width: 500
    height: 800
    property real heightSpace: height / 20
    property real widthSpace: 30
    Image {
        id: background
        width: parent.width
        height: parent.height
        source: "images/background.png"
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle {
        id: title
        height: parent.height / 8
        anchors.top: parent.top
        anchors.topMargin: parent.heightSpace
        anchors.left: parent.left
        anchors.leftMargin: parent.widthSpace
        anchors.right: parent.right
        anchors.rightMargin: parent.widthSpace
        radius: 10
        border.color: "#550000"
        border.width: 4
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#c88716"}
            GradientStop {position: 1.0; color: "#c8b069"}
        }
        Text {
            id: gameName
            text: "五 子 棋"
            color: "#550000"
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 100
        }
    }
    Item {
        id: checkerboard
        width: title.width
        height: width
        anchors.top: title.bottom
        anchors.topMargin: parent.heightSpace
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            anchors.fill: parent
            source: "images/checkerboard.png"
            fillMode: Image.PreserveAspectCrop
        }
        Canvas {
            anchors.fill: parent
            contextType: "2d"
            onPaint: {
                context.lineWidth = 4;
                context.strokeStyle = "#550000";
                var startX = touchArea.cellSize / 2;
                var startY = touchArea.cellSize / 2;
                var endX = width - touchArea.cellSize / 2;
                var endY = touchArea.cellSize / 2;
                context.beginPath();
                var i;
                for(i = 0; i < touchArea.cellNumber; i++){
                    context.moveTo(startX, startY+i*touchArea.cellSize);
                    context.lineTo(endX, endY+i*touchArea.cellSize);
                }
                endY = endX;
                endX = startX;
                for(i = 0; i < touchArea.cellNumber; i++){
                    context.moveTo(startX+i*touchArea.cellSize, startY);
                    context.lineTo(endX+i*touchArea.cellSize, endY);
                }
                context.stroke();
            }
        }
        Item {
            id: touchArea
            anchors.fill: parent
            enabled: false
            property int cellNumber: 15
            property real cellSize: width / cellNumber
            property int chessType: 0
            /*
            ComputerGo {
                id: computer
            }
            */
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var pos = LOGIC_CAL.handleClicked(mouse.x, mouse.y, touchArea.chessType);
                    if(pos != undefined){
                        touchArea.enabled = false;
                        computer.getChessPos(pos[0], pos[1]);
                    }
                }
            }
            Connections {
                target: computer
                onSendChessPos: { // 计算机返回一个坐标
                    var newX = column * touchArea.cellSize + 5;
                    var newY = row * touchArea.cellSize + 5;
                    var pos = LOGIC_CAL.handleClicked(newX, newY, touchArea.chessType^1);
                    if(pos[2] == undefined){ // 游戏还没有结束
                        touchArea.enabled = true;
                    }
                }
            }
        }
        MsgDialog {
            id: endState
            width: parent.width / 2
            height: parent.height / 3
            anchors.centerIn: parent
            visible: false
            z: 20
            onAcceptButtonClicked: {
                visible = false;
            }
        }
    }
    Row {
        //width: title.width
        //height: 200
        id: buttonList
        spacing: 20
        anchors.top: checkerboard.bottom
        anchors.topMargin: parent.heightSpace
        anchors.horizontalCenter: parent.horizontalCenter
        property int isFirst: 0
        ControlButton {
            id: choseFirst
            buttonText: "后手"
            buttonTextColor: "#550000"
            buttonSize: 70
            width: root.width / 4
            height: root.height / 15
            onClicked: {
                if(buttonList.isFirst){
                    buttonList.isFirst = 0;
                    buttonText = "后手";
                }else{
                    buttonList.isFirst = 1;
                    buttonText = "先手";
                }
            }
        }
        ControlButton {
            id: beginButton
            buttonText: "开始"
            buttonTextColor: "#550000"
            buttonSize: 70
            width: root.width / 4
            height: root.height / 15
            onClicked: {
                if(buttonText == "开始"){
                    touchArea.chessType = 1; // 己方为白棋子（黑棋为 0）
                    LOGIC_CAL.init(buttonList.isFirst);
                    if(buttonList.isFirst == 0){ // 计算机为先手
                        computer.initFirst(Math.floor(touchArea.cellNumber/2),
                                           Math.floor(touchArea.cellNumber/2));
                    }
                    touchArea.enabled = true;
                    buttonText = "重来";
                    choseFirst.enabled = false;
                    choseFirst.buttonTextColor = "#747474";
                }else{
                    LOGIC_CAL.clearChessmans();
                    computer.clearChess();
                    touchArea.enabled = false;
                    buttonText = "开始";
                    choseFirst.enabled = true;
                    choseFirst.buttonTextColor = "#550000";
                }
            }
        }
        ControlButton {
            id: quitButton
            buttonText: "退出"
            buttonTextColor: "#550000"
            buttonSize: 70
            width: root.width / 4
            height: root.height / 15
            onClicked: {
                Qt.quit();
            }
        }
    }
}
