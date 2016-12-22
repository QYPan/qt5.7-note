import QtQuick 2.4
import QtQuick.Controls 1.3
import ClientMap 1.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    height: parent.height
    ListView {
        id: systemView
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                title: "五子棋"
            }
        }
        delegate: Item {
            width: parent.width
            height: Screen.height * 0.08
            Rectangle {
                anchors.fill: parent
                color: "#11ffffff"
                visible: mouse.pressed
            }
            Text {
                id: textitem
                color: "white"
                font.pixelSize: 60
                text: title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 50
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 15
                height: 1
                color: "#424246"
            }
            Image {
                width: 70
                height: 70
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/navigation_next_item.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: {
                    stackView.push(Qt.resolvedUrl("../content/GobangPage.qml"));
                }
            }
        }
    }
}
