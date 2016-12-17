import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import ClientSocket 1.0
import "content"

Item {
    id: root
    width: 500
    height: 700
    /*
    ClientSocket {
        id: socket
    }
    */
    LoginPage {
        id: loginPage
        anchors.fill: parent
    }
    StackView {
        id: stackView // 实现翻页
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }
    }
    function manage(array){
        var name = array[0];
        var mark = parseInt(array[1]);
        var message = array[2];
        if(mark === ClientSocket.LOGIN_SUCCESSED){
            socket.clientName = name; // 把用户名记录在 socket 组件
            loginPage.visible = false;
            stackView.push(Qt.resolvedUrl("content/MainTab.qml"));
            socket.getUsersSignal();
        }else if(mark === ClientSocket.LOGIN_FAILURE){
            loginPage.dialogVisible = true;
            loginPage.dialogMessage = message;
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
    function splitData(data){
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
        onReadDataSignal: {
            console.log("data: " + data);
            var arr = root.splitData(data); // 把 socket 收到的数据按分 3 份
            console.log("arr:" + arr);
            root.manage(arr); // 判断数据类型并转发给子组件
        }
    }
}
