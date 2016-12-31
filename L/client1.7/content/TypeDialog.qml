import QtQuick 2.0

Rectangle {
    id: dialog
    width: parent.width / 2
    height: parent.height / 5
    anchors.centerIn: parent
    property alias dialogMessage: dialogMessage.text
    property alias textColor: dialogMessage.color
    signal buttonClicked()
    z: 20
    gradient: Gradient {
                GradientStop {position: 0.0; color: "#969696"}
                GradientStop {position: 1.0; color: "#242424"}
    }
    Item {
        id: textBackground
        width: parent.width
        height: parent.height / 2
        Text {
            id: dialogMessage
            width: parent.width
            anchors.centerIn: parent
            wrapMode: Text.WrapAnywhere
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
                buttonClicked();
            }
        }
    }
}
