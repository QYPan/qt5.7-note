import QtQuick 2.4
import QtQuick.Controls 1.3
import ClientMap 1.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    height: parent.height
    Component {
        id: aboutPage
        Rectangle {
            property bool isTalkPage: false
            color: "#212126"
            BorderImage {
                id: topView
                border.bottom: 8
                source: "../images/toolbar.png"
                width: parent.width
                height: Screen.height * 0.07
                Rectangle {
                    id: backButton
                    width: opacity ? parent.height*0.7 : 0
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    opacity: stackView.depth > 1 ? 1 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    antialiasing: true
                    height: parent.height * 0.7
                    radius: 4
                    color: backmouse.pressed ? "#222" : "transparent"
                    Behavior on opacity { NumberAnimation{} }
                    Image {
                        anchors.fill: parent
                        source: "../images/navigation_previous_item.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    MouseArea {
                        id: backmouse
                        anchors.fill: parent
                        //anchors.margins: -10
                        onClicked: stackView.pop()
                    }
                }

                Text {
                    id: title
                    font.pixelSize: 60
                    Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                    x: backButton.x + backButton.width + 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    text: "关于"
                }
            }
            TextEdit {
                id: aboutText
                anchors.top: topView.bottom
                anchors.topMargin: topView.height / 5
                anchors.left: parent.left
                anchors.leftMargin: topView.height / 5
                anchors.right: parent.right
                anchors.rightMargin: topView.height / 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: topView.height / 5
                wrapMode: TextEdit.WrapAnywhere
                color: "white"
                font.pixelSize: 60
                readOnly: true
                text:
                    "功能：\n" +
                    "- 支持私聊\n" +
                    "- 支持发送文本消息\n" +
                    "- 支持用户消息缓存\n" +
                    "- 支持消息提醒\n" +
                    "- 支持中英互译（点击消息可获取翻译，点击翻译结果可隐藏翻译，需要联网）\n\n" +
                    "注意：\n" +
                    "- 登录不需要密码\n" +
                    "- 用户名不可与已在线用户名相同\n" +
                    "- 暂时不提供返回键的支持\n" +
                    "- 退出应用后消息记录会清除\n" +
                    "- 网络环境较差会断开连接\n" +
                    "- 若连接断开，则需要退出重新登录"
            }
        }
    }

    ListView {
        id: systemView
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                title: "关于"
            }
            ListElement {
                title: "退出"
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
                source: title === "关于" ? "../images/navigation_next_item.png" : "../images/quit.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: {
                    if(title === "退出"){
                        Qt.quit();
                    }else{
                        stackView.push(aboutPage); // 引用 main.qml 的 stackView 组件
                    }
                }
            }
        }
    }
}
