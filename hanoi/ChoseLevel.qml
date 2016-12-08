import QtQuick 2.0

Item {
    signal choseClicked(int level)
    Grid {
        //anchors.fill: parent
        anchors.centerIn: parent
        columns: 5
        spacing: 10
        Repeater {
            model: 10
            Rectangle {
                width: 170
                height: 80
                color: "green"
                border.color: "yellow"
                border.width: 2
                radius: 5
                Text {
                    text: index + 1
                    anchors.centerIn: parent
                    color: "yellow"
                    font.bold: true
                    font.pixelSize: 40
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: choseClicked(index + 1);
                }
            }
        }
    }
}
