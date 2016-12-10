import QtQuick 2.0

Item {
    id: msgDialog
    property int type: 0
    signal acceptButtonClicked()
    Rectangle {
        id: background
        anchors.fill: parent
        border.color: "#b8c89a"
        border.width: 2
        radius: 5
        //opacity: 0.5
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#c5c814"}
            GradientStop {position: 1.0; color: "#c8a871"}
        }
    }
    Item {
        id: msg
        width: parent.width
        height: parent.height / 2
        Text {
            text: {
                if(type == 0)
                    return "黑方胜";
                else
                    return "白方胜";
            }
            color: "#55007f"
            font.bold: true
            font.pixelSize: 90
            anchors.centerIn: parent
        }
    }
    Item {
        width: parent.width
        height: parent.height / 2
        anchors.top: msg.bottom
        signal gefef()
        ControlButton {
            id: acceptButton
            width: parent.width / 2
            height: parent.height / 2
            buttonText: "确定"
            buttonTextColor: "#550000"
            buttonSize: 50
            anchors.centerIn: parent
            onClicked: {
                acceptButtonClicked();
            }
        }
    }
}
