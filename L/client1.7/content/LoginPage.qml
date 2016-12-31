import QtQuick 2.0
import QtQuick.Layouts 1.1
import QmlInterface 1.0

/*
  提供暴露用户名，登陆按钮
*/

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    //color: "#4b4b4b"
    //color: "#4e4e4e"
    color: "black"
    property alias userName: inputName.text
    property alias dialogVisible: loginDialog.visible
    property alias dialogMessage: loginDialog.dialogMessage
    /*
    gradient: Gradient {
                GradientStop {position: 0.5; color: "#242424"}
                GradientStop {position: 1.0; color: "#969696"}
    }
    */
    TypeDialog {
        id: loginDialog
        visible: false;
        onButtonClicked: {
            loginDialog.visible = false;
            loginButton.text = qsTr("登 录");
            inputName.enabled = true;
            loginButton.enabled = true;
        }
    }

    BorderImage {
        id: logo
        width: parent.width / 4
        height: parent.height * 0.5
        border.bottom: width * 0.9
        border.left: 5
        border.right: 5
        source: "../images/LLogo.png"
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TextInputLine {
        id: inputName
        width: parent.width * 0.65
        font.pixelSize: 55
        height: 80
        maximumLength: 15
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
        height: 90
        anchors.top: inputName.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            inputName.enabled = false;
            loginButton.enabled = false;
            if(userName === ""){
                loginDialog.dialogMessage = "请先输入用户名"
                loginDialog.visible = true;
            }else{
                loginButton.text = "连 接 中..."
                qmlInterface.clientName = inputName.text
                qmlInterface.tryConnect();
            }
        }
    }
    Connections {
        target: qmlInterface
        onDisplayError: {
            loginDialog.dialogMessage = message;
            loginDialog.visible = true;
            loginButton.text = qsTr("登 录");
        }
    }
}
