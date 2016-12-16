import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import ClientSocket 1.0

Item {
    id: root
    width: 500
    height: 700
    ClientSocket {
        id: socket
    }
    LoginPage {
        id: loginPage
        anchors.fill: parent
        onLoginButtonClicked: {
            if(userName === ""){
                dialogMessage.text = "请先输入用户名"
                dialog.visible = true;
            }else{
                buttonText = "连 接 中..."
                socket.connectSignal(userName);
            }
        }
        Rectangle {
            id: dialog
            width: parent.width / 2
            height: parent.height / 5
            anchors.centerIn: parent
            z: 20
            visible: false
            gradient: Gradient {
                        GradientStop {position: 0.0; color: "#242424"}
                        GradientStop {position: 1.0; color: "#969696"}
            }
            Item {
                id: textBackground
                width: parent.width
                height: parent.height / 2
                Text {
                    id: dialogMessage
                    anchors.centerIn: parent
                }
            }
            Item {
                width: parent.width
                height: parent.height / 2
                anchors.top: textBackground.bottom
                TypeButton {
                    id: dialogButton
                    text: "确 定"
                    width: parent.width * 0.7
                    height: parent.height * 0.55
                    anchors.centerIn: parent;
                    onClicked: {
                        dialog.visible = false;
                        loginPage.buttonText = "登 录";
                    }
                }
            }
        }
    }
    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }
        function manage(array){
            var name = array[0];
            var mark = parseInt(array[1]);
            var message = array[2];
            if(mark === ClientSocket.LOGIN_SUCCESSED){
                loginPage.visible = false;
                socket.clientName = name;
                stackView.push(Qt.resolvedUrl("MainTab.qml"));
                socket.getUsersSignal();
            }else if(mark === ClientSocket.LOGIN_FAILURE){
                dialog.visible = true;
                dialogMessage.text = message;
            }else if(mark === ClientSocket.ADD_SUCCESSED){
                var users = message.split("#");
                var i;
                for(i = 0; i < users.length; i++){
                    stackView.get(0).addUser(users[i]);
                }
            }else if(mark === ClientSocket.TRANSPOND_SUCCESSED){
                console.log("get message from " + message);
                var toName = message.split("#", 1)
                var toMessage = message.substring(toName[0].length+1);
                console.log("toName: " + toName[0]);
                console.log("toMessage: " + toMessage);
                stackView.get(0).receiveMessage(toName[0], toMessage);
            }else if(mark === ClientSocket.OFFLINE){
                stackView.get(0).removeUser(message);
            }
        }

    }
    function splitData(data){ // 把 socket 收到的数据按分 3 份
        var arr = new Array;
        var i;
        var beg = 0;
        var count = 0;
        for(i = 0; i < data.length; i++){
            if(data[i] === "#"){
                arr[count] = data.substring(beg, i);
                count++;
                beg = i + 1;
                if(count === 2)
                    break;
            }
        }
        if(beg === data.length) arr[count] = "";
        else arr[count] = data.substring(beg);
        return arr;
    }
    Connections {
        target: socket
        onDisplayConnectError: {
            dialogMessage.text = message;
            dialog.visible = true;
            loginPage.buttonText = "登 录"
        }
    }
    Connections {
        target: socket
        onReadDataSignal: {
            console.log("data: " + data);
            var arr = splitData(data);
            console.log("arr:" + arr);
            stackView.manage(arr);
        }
    }
}
