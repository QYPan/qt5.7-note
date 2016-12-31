import QtQuick 2.0
import QtQuick.Window 2.0
import "gobanglogic.js" as LOGIC_CAL

Rectangle {
    id: root
    color: "#212126"
    property alias gameName: title.text
    property bool isTalkPage: false
    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Rectangle {
            id: backButton
            width: opacity ? parent.height*0.7 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height * 0.7
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.fill: parent
                source: "../images/navigation_previous_item.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                //anchors.margins: -10
                onClicked:{
                    LOGIC_CAL.clearChessmans();
                    computer.clearChess();
                    stackView.pop();
                }
            }
        }

        Text {
            id: title
            font.pixelSize: 60
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "五子棋"
        }
    }
    Item {
        id: checkerboard
        width: parent.width * 0.97
        height: width
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 1.3
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            anchors.fill: parent
            source: "../images/button_default.png"
            fillMode: Image.PreserveAspectCrop
        }
        Canvas {
            anchors.fill: parent
            contextType: "2d"
            onPaint: {
                context.lineWidth = 4;
                context.strokeStyle = "#212126";
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

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var pos = LOGIC_CAL.handleClicked(mouse.x, mouse.y, touchArea.chessType);
                    if(pos != undefined){
                        if(pos[2] == undefined){ // 游戏尚未结束
                            touchArea.enabled = false;
                            computer.getChessPos(pos[0], pos[1]);
                            beginButton.enabled = false;
                            beginButton.buttonPressed = true;
                            fuckButton.enabled = false;
                            fuckButton.buttonPressed = true;
                        }
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
                        beginButton.enabled = true;
                        beginButton.buttonPressed = false;
                        fuckButton.enabled = true;
                        fuckButton.buttonPressed = false;
                    }
                }
            }
        }
        TypeDialog {
            id: endState
            width: parent.width / 2
            height: parent.width / 3
            visible: false
            z: 20
            property bool fuck: false
            property bool ended: false
            onButtonClicked: {
                visible = false;
                if(fuck){
                    touchArea.enabled = true;
                    fuck = false;
                }
                beginButton.enabled = true;
                beginButton.buttonPressed = false;
                fuckButton.enabled = true;
                fuckButton.buttonPressed = false;
            }
        }
    }

    Row {
        //width: title.width
        //height: 200
        id: buttonList
        spacing: 40
        anchors.top: checkerboard.bottom
        anchors.topMargin: topView.height * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        property int isFirst: 0
        TypeButton {
            id: choseFirst
            text: "后手"
            textSize: 70
            width: root.width / 4
            height: topView.height * 0.8
            onClicked: {
                if(buttonList.isFirst){
                    buttonList.isFirst = 0;
                    text = "后手";
                }else{
                    buttonList.isFirst = 1;
                    text = "先手";
                }
            }
        }
        TypeButton {
            id: beginButton
            text: "开始"
            textSize: 70
            width: root.width / 4
            height: topView.height * 0.8
            onClicked: {
                if(text == "开始"){
                    touchArea.chessType = 1; // 己方为白棋子（黑棋为 0）
                    LOGIC_CAL.init(buttonList.isFirst);
                    if(buttonList.isFirst == 0){ // 计算机为先手
                        computer.initFirst(Math.floor(touchArea.cellNumber/2),
                                           Math.floor(touchArea.cellNumber/2));
                    }
                    touchArea.enabled = true;
                    text = "重来";
                    endState.ended = false;
                    choseFirst.enabled = false;
                    choseFirst.buttonPressed = true;
                }else{
                    LOGIC_CAL.clearChessmans();
                    computer.clearChess();
                    touchArea.enabled = false;
                    text = "开始";
                    choseFirst.enabled = true;
                    choseFirst.buttonPressed = false;
                }
            }
        }
        TypeButton {
            id: fuckButton
            text: "悔棋"
            textSize: 70
            width: root.width / 4
            height: topView.height * 0.8
            property bool lock: false
            onClicked: {
                if(beginButton.text === "重来" && endState.ended === false){
                    endState.dialogMessage = "尚未打算实现该功能"
                    endState.fuck = true;
                    endState.visible = true;
                    touchArea.enabled = false;
                    beginButton.enabled = false;
                    beginButton.buttonPressed = true;
                    enabled = false;
                    fuckButton.buttonPressed = true;
                }
            }
        }
    }
    TypeButton {
        id: quitButton
        text: "退出"
        textSize: 70
        width: root.width / 4
        height: topView.height * 0.8
        anchors.top: buttonList.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            LOGIC_CAL.clearChessmans();
            computer.clearChess();
            stackView.pop();
        }
    }
}
