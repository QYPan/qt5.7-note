import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

Rectangle {
    id: root
    property alias userName: title.text
    signal sendMessage(string msg)
    color: "#4b4b4b"
    BorderImage {
        id: topView
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.09

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
                source: "images/navigation_previous_item.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                //anchors.margins: -10
                onClicked: stackView.pop()
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
        anchors.margins: 4
        clip: true
        spacing: 20
        model: ListModel {}
        delegate: Item{
            id: perDelegate
            width: parent.width
            //height: 100
            height: msg.height + 15 > manIcon.height ? msg.height + 15 : manIcon.height
            property int limitLength: width - 2 * (48 + 20)
            Rectangle {
                id: manIcon
                x: who ? 0 : parent.width - manIcon.width
                width: 48
                height: 48
                color: "blue"
            }
            Rectangle {
                id: msgBackground
                x: who ? manIcon.width + 20 : parent.width - manIcon.width - 20 - width
                y: 0
                width: msg.width + 15
                height: msg.height + 15 > manIcon.height ? msg.height + 15 : manIcon.height
                color: "gray"
                Text {
                    id: msg
                    anchors.centerIn: parent
                    width: msgLength < perDelegate.limitLength? msgLength : perDelegate.limitLength
                    text: getMsg
                    wrapMode: Text.WrapAnywhere
                    font.pixelSize: 40
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
        width: parent.width * 0.65
        height: parent.height * 0.09
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        TextInputLine {
            id: inputMessage
            width: parent.width
            anchors.centerIn: parent
        }
    }
    TypeButton {
        id: sendButton
        width: parent.width * 0.17
        height: messageBackground.height * 0.6
        text: "发送"
        anchors.left: messageBackground.right
        anchors.verticalCenter: messageBackground.verticalCenter
        onClicked: {
            root.appendMsg(inputMessage.text, 0);
            inputMessage.remove(0, inputMessage.length);
        }
    }
    Text {
        id: msgDont
        visible: false
        font.pixelSize: 40
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
