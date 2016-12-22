import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QmlInterface 1.0
import "content"

ApplicationWindow {
    objectName: "rootObject"
    visible: true
    id: root
    width: 500
    height: 700
    /*
    ClientSocket {
        id: socket
    }
    */
    LoginPage {
        objectName: "loginPage"
        id: loginPage
        anchors.fill: parent
    }
    property int removeFlag: -1

    StackView {
        objectName: "stackObject"
        id: stackView // 实现翻页
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        /*
        Keys.onReleased: if (event.key === Qt.Key_Back) {
                             //stackView.pop();
                             if(stackView.depth)
                                 event.accepted = true;
                         }
                         */
        onBusyChanged: {
            if(stackView.busy === false && removeFlag !== -1){
                stackView.get(0).directRemoveUser(removeFlag);
                removeFlag = -1;
            }
        }
    }
    function manage(mark, message){
        if(mark === QmlInterface.LOGIN_SUCCESSED){
            loginPage.visible = false;
            stackView.push(Qt.resolvedUrl("content/MainTab.qml"));
            qmlInterface.qmlSendData(QmlInterface.ADD_ALL, "");
        }else if(mark === QmlInterface.LOGIN_FAILURE){
            loginPage.dialogVisible = true;
            loginPage.dialogMessage = message;
        }else if(mark === QmlInterface.ADD_SUCCESSED){
            var users = message.split("#");
            var i;
            for(i = 0; i < users.length; i++){
                stackView.get(0).addUser(users[i]);
            }
        }else if(mark === QmlInterface.TRANSPOND_SUCCESSED){
            console.log("get message from " + message);
            var toName = message.split("#", 1)
            var toMessage = message.substring(toName[0].length+1);
            console.log("toName: " + toName[0]);
            console.log("toMessage: " + toMessage);
            stackView.get(0).receiveMessage(toName[0], toMessage);
        }else if(mark === QmlInterface.OFFLINE){
            stackView.get(0).removeUser(message);
            removeFlag = stackView.get(0).flag;
        }
    }
    Connections {
        target: backKeyFilter
        onTouchBackKey: {
            if(stackView.depth === 0)
                Qt.quit();
            console.log("back in qml");
        }
    }

    Connections {
        target: qmlInterface
        onQmlReadData: {
            manage(type, message);
        }
    }
}
