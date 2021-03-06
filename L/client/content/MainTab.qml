import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.0

Item {
    id: root
    width: parent.width
    height: parent.height
    //property alias listView: clientList.listView
    signal addUser(string name)
    signal removeUser(string name)
    signal receiveMessage(string name, string message)
    signal directRemoveUser(int id)
    property int flag: -1

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    TypeDialog {
        id: disconnectDialog
        visible: false
        anchors.centerIn: parent
        Connections {
            target: qmlInterface
            onDisplayError: {
                disconnectDialog.dialogMessage = message;
                disconnectDialog.visible = true;
            }
        }
        onButtonClicked: {
            disconnectDialog.visible = false;
        }
    }

    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Text {
            font.pixelSize: 100
            x: 50
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "L"
        }
    }

    TabView {
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        style: touchStyle
        tabPosition: Qt.BottomToolBarArea
        Tab {
            title: qsTr("在线")
            ClientList {
                id: clientList
                anchors.fill: parent
                Connections {
                    target: root
                    onAddUser: {
                        clientList.addOne(name);
                    }
                }
                Connections {
                    target: root
                    onRemoveUser: {
                        flag = clientList.removeOne(name);
                    }
                }
                Connections {
                    target: root
                    onReceiveMessage: {
                        clientList.receiveMessage(name, message);
                    }
                }
                Connections {
                    target: root
                    onDirectRemoveUser: {
                        clientList.directRemove(id);
                    }
                }
            }
        }
        Tab {
            title: qsTr("游戏")
            Games {}
        }
        Tab {
            title: qsTr("系统")
            System {}
        }
    }

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item { }
            tab: Item {
                implicitWidth: control.width/control.count
                implicitHeight: Screen.height * 0.07
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "../images/tabs_standard.png":"../images/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: styleData.selected ? "#3399ff" : "white"
                        text: styleData.title
                        font.pixelSize: 45
                    }
                    Rectangle {
                        visible: index > 0
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width:1
                        color: "#3a3a3a"
                    }
                }
            }
        }
    }
}
