import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

Rectangle {
    id: root
    property alias userName: title.text
    property bool isTalkPage: true
    signal sendMessage(string msg)
    color: "#212126"
    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Rectangle {
            id: backButton
            width: opacity ? 70 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 70
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
            text: "L"
        }
    }
    ListView {
        id: messageListView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topView.bottom
        anchors.bottom: separationLine.top
        anchors.margins: topView.height / 5
        clip: true
        spacing: topView.height * 0.3
        model: ListModel {}
        delegate: Item{
            id: perDelegate
            property int edge: 2 * topView.height / 5
            width: parent.width
            //height: 200
            height: msg.height+edge > manIcon.height ? msg.height+edge : manIcon.height
            property int limitLength: width - 2 * manIcon.width - 3 * edge
            Rectangle {
                id: manIcon
                x: who ? 0 : parent.width - manIcon.width
                width: topView.height * 0.8
                height: width
                color: "#212126"
                Image {
                    id: head
                    anchors.fill: parent
                    source: who ? "../images/headleft.png" : "../images/headright.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            Canvas {
                id: triangleLeft
                visible: who
                x: manIcon.width
                width: edge
                height: manIcon.height
                contextType: "2d"
                onPaint: {
                    context.lineWidth = 0;
                    context.strokeStyle = "#c0c0c0";
                    context.fillStyle = "#c0c0c0";
                    var startX = width / 2;
                    var startY = height / 2;
                    context.beginPath();
                    context.moveTo(startX, startY);
                    context.lineTo(width, height/3);
                    context.lineTo(width, 2*height/3);
                    context.closePath();
                    context.fill();
                    context.stroke();
                }
            }
            Canvas {
                id: triangleRight
                visible: who ? false : true
                x: parent.width - manIcon.width - edge
                width: edge
                height: manIcon.height
                contextType: "2d"
                onPaint: {
                    context.lineWidth = 0;
                    context.strokeStyle = "#808080";
                    context.fillStyle = "#808080";
                    var startX = width / 2;
                    var startY = height / 2;
                    context.beginPath();
                    context.moveTo(startX, startY);
                    context.lineTo(0, height/3);
                    context.lineTo(0, 2*height/3);
                    context.closePath();
                    context.fill();
                    context.stroke();
                }
            }
            Rectangle {
                id: msgBackground
                x: who ? manIcon.width+edge : parent.width-manIcon.width-edge-width
                y: 0
                width: msg.width + edge
                height: msg.height+edge > manIcon.height ? msg.height+edge : manIcon.height
                radius: 6
                color: who ? "#c0c0c0" : "#808080"
                Text {
                    id: msg
                    anchors.centerIn: parent
                    width: msgLength < perDelegate.limitLength? msgLength : perDelegate.limitLength
                    text: getMsg
                    wrapMode: Text.WrapAnywhere
                    font.pixelSize: 50
                }
            }
        }
        currentIndex: count - 1
    }
    Rectangle {
        id: separationLine
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: messageBackground.top
        anchors.bottomMargin: 5
        height: 1
        color: "gray"
    }

    Item {
        id: tag
        width: parent.width * 0.17
        height: messageBackground.height
        anchors.right: messageBackground.left
        anchors.verticalCenter: messageBackground.verticalCenter
        Text {
            text: "消息:"
            color: "white"
            font.pixelSize: 50
            anchors.centerIn: parent
        }
    }
    Item {
        id: messageBackground
        width: parent.width * 0.6
        height: parent.height * 0.09
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        TextInputLine {
            id: inputMessage
            width: parent.width
            font.pixelSize: 50
            anchors.centerIn: parent
        }
    }
    TypeButton {
        id: sendButton
        width: parent.width * 0.15
        height: messageBackground.height * 0.5
        text: "发 送"
        textSize: 45
        anchors.right: separationLine.right
        anchors.verticalCenter: messageBackground.verticalCenter
        onClicked: {
            if(inputMessage.length){
                root.appendMsg(inputMessage.text, 0);
                inputMessage.remove(0, inputMessage.length);
            }
        }
    }
    Text {
        id: msgDont
        visible: false
        font.pixelSize: 50
    }
    function appendMsg(msgStr, flag){
        msgDont.text = msgStr;
        var len = msgDont.width;
        messageListView.model.append({"who" : flag,
                               "getMsg" : msgStr,
                               "msgLength" : len});
        if(flag === 0)
            sendMessage(msgStr);
    }

    function addMessage(message){
        var buffer = new Array;
        buffer = message.split("\n");
        var i;
        for(i = 0; i < buffer.length; i++)
            appendMsg(buffer[i], 1);
        //displayMessage.text += "\n" + message;
    }
}
