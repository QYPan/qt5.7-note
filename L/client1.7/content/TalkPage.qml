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
                    stackView.pop();
                }
            }
        }

        Text {
            id: title
            font.pixelSize: 60
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 30
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
                visible: !isBox
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
                    context.strokeStyle = "#686868";
                    context.fillStyle = "#686868";
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
                color: who ? (textTouch.pressed ? "#969696" : "#c0c0c0")
                           :(textTouch.pressed ? "#4b4b4b" : "#686868")
                Text {
                    id: msg
                    anchors.centerIn: parent
                    width: msgLength < perDelegate.limitLength? msgLength : perDelegate.limitLength
                    text: getMsg
                    wrapMode: Text.WrapAnywhere
                    font.pixelSize: 50
                }
                MouseArea {
                    id: textTouch
                    anchors.fill: parent
                    property var reverse: null
                    onClicked: {
                        if(isBox === false){
                            if(canClick === true){
                                if(reverse === null){
                                    var request = new XMLHttpRequest();
                                    var str = "http://fanyi.youdao.com/openapi.do?keyfrom=english-2-chinese&key=1263917877&type=data&doctype=json&version=1.1&q=";
                                    console.log(str+msg.text);
                                    request.open("GET", str+msg.text)
                                    request.send();
                                    request.onreadystatechange = function(){
                                        if(request.readyState === 4 && request.status === 200){
                                            var ans = request.responseText;
                                            reverse = JSON.parse(ans).translation[0];
                                            addBox(index+1, who, reverse);
                                        }else{
                                        }
                                    }
                                }else{
                                    addBox(index+1, who, reverse);
                                }
                                canClick = false;
                            }
                        }else{
                            removeBox(index);
                        }
                    }
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
    function addBox(h, flag, msgStr){
        msgDont.text = msgStr;
        var len = msgDont.width;
        messageListView.model.insert(h, {"who" : flag, "isBox" : true,
                                         "canClick" : true,
                                         "getMsg" : msgStr, "msgLength" : len});
    }
    function appendMsg(msgStr, flag){
        msgDont.text = msgStr;
        var len = msgDont.width;
        messageListView.model.append({"who" : flag,
                               "isBox" : false,
                               "getMsg" : msgStr,
                               "canClick" : true,
                               "msgLength" : len});
        if(flag === 0)
            sendMessage(msgStr);
    }
    function removeBox(h){
        messageListView.model.remove(h);
        messageListView.model.setProperty(h-1, "canClick", true);
    }
    function translateWord(msg){
        var request = new XMLHttpRequest();
        var str = "http://fanyi.youdao.com/openapi.do?keyfrom=english-2-chinese&key=1263917877&type=data&doctype=json&version=1.1&q=";
        console.log(str+msg);
        request.open("GET", str+msg)
        request.send();
        request.onreadystatechange = function(){
            if(request.readyState === 4 && request.status === 200){
                var ans = request.responseText;
                var reverse = JSON.parse(ans);
                console.log(reverse.translation[0]);
                //request = null;
                return reverse.translation[0];
                /*
                */
            }else{
                //console.log("error!");
            }
        }
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
