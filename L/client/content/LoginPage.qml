import QtQuick 2.0
import QtQuick.Layouts 1.1

/*
  提供暴露用户名，登陆按钮
*/

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#4b4b4b"
    property alias userName: inputName.text
    property alias dialogVisible: dialog.visible
    property alias dialogMessage: dialogMessage.text
    /*
    gradient: Gradient {
                GradientStop {position: 0.5; color: "#242424"}
                GradientStop {position: 1.0; color: "#969696"}
    }
    */
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
                text: qsTr("确 定")
                width: parent.width * 0.7
                height: parent.height * 0.55
                anchors.centerIn: parent;
                onClicked: {
                    dialog.visible = false;
                    loginButton.text = qsTr("登 录");
                }
            }
        }
    }
    BorderImage {
        id: logo
        border.bottom: 280
        border.left: 5
        border.right: 5
        source: "../images/LLogo.png"
        width: parent.width / 4
        height: parent.height * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TextInputLine {
        id: inputName
        width: parent.width * 0.5
        font.pixelSize: 50
        height: 80
        horizontalAlignment: TextInput.AlignHCenter
        anchors.top: logo.bottom
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        focus: false
    }
    TypeButton {
        id: loginButton
        text: qsTr("登 录");
        width: inputName.width
        height: 80
        anchors.top: inputName.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if(userName === ""){
                dialogMessage.text = "请先输入用户名"
                dialog.visible = true;
            }else{
                loginButton.text = "连 接 中..."
                socket.connectSignal(userName);
            }
        }
    }
    Connections {
        target: socket // 引用 main.cpp 的 socket 组件
        onDisplayConnectError: {
            dialogMessage.text = message;
            dialog.visible = true;
            loginButton.text = qsTr("登 录");
        }
    }
}
