import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: diglog
    width: 400
    height: 300
    color: "#342342"
    border.color: "#679766"
    border.width: 3
    radius: 5
    signal clearDisc()
    Column {
        anchors.fill: parent
        Item {
            width: 400
            height: 150
            Text {
                id: msg
                anchors.centerIn: parent
                font.bold: true
                font.pixelSize: 50
                text: "good job!"
                color: "green"
            }
        }
        Item {
            width: 400
            height: 150
            Button {
                id: nextButton
                anchors.centerIn: parent
                style: ButtonStyle {
                    background: Rectangle {
                        color: "#ffda33"
                        implicitWidth: 150
                        implicitHeight: 70
                        border.color: (control.hovered || control.pressed)
                                        ? "#987323" : "#678856"
                        border.width: control.pressed ? 3 : 1
                        Text {
                            text: "next"
                            anchors.centerIn: parent
                            font.bold: true
                            font.pixelSize: 50
                            color: "#444faf"
                        }
                    }
                }
                onClicked: {
                    clearDisc();
                }
            }
        }
    }
}
