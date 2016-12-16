import QtQuick 2.0
import QtQuick.Layouts 1.1

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#4b4b4b"
    property alias userName: inputName.text
    property alias buttonText: loginButton.text
    signal loginButtonClicked()
    /*
    gradient: Gradient {
                GradientStop {position: 0.5; color: "#242424"}
                GradientStop {position: 1.0; color: "#969696"}
    }
    */
    BorderImage {
        id: logo
        border.bottom: 280
        border.left: 5
        border.right: 5
        source: "images/LLogo.png"
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
        focus: true
    }
    TypeButton {
        id: loginButton
        text: "登 录"
        width: inputName.width
        height: 80
        anchors.top: inputName.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            loginButtonClicked();
        }
    }
}
