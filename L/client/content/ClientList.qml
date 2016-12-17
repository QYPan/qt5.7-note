import QtQuick 2.4
import QtQuick.Controls 1.3
import ClientMap 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    ClientMap {
        id: clientMap
    }
    ListView {
        id: clientListView
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: ItemDelegate {
            id: client
            text: title
            numberText: numberValue
            onClicked:{
                var obj = Qt.createComponent("../content/TalkPage.qml");
                if(obj.status === Component.Ready){
                    var item = obj.createObject();
                    item.userName = title;
                    item.sendMessage.connect(client.sendData);
                    if(clientMap.has(title)){ // 如果有 title 用户的缓存消息
                        item.addMessage(clientMap.get(title)); // 把消息加入聊天页面
                        clientMap.clear(title); // 清空对 title 的缓存消息
                        numberText = "0";
                    }
                    client.ListView.view.currentIndex = index;
                    stackView.push(item);
                }
            }
            function sendData(message){
                var newMessage = title + "#";
                newMessage += message;
                socket.sendDataSignal(newMessage); // 引用 main.cpp 的全局的 socket 组件
            }
        }
    }
    function addOne(userName){
        clientListView.model.append({"title" : userName, "numberValue" : "0"});
    }
    function removeOne(userName){
        var i;
        for(i = 0; i < clientListView.count; i++){
            var currentItem = clientListView.model.get(i);
            if(currentItem.title === userName){
                clientListView.model.remove(i);
                if(clientListView.currentIndex === i){ // 已经打开与 userName 的聊天页面
                    //var popPage = stackView.get(1);
                    stackView.pop(); // 删除用户的同时把页面 pop 掉
                    //popPage.destroy();
                }
            }
        }
    }
    function receiveMessage(userName, message){
        var i;
        for(i = 0; i < clientListView.count; i++){
            var currentItem = clientListView.model.get(i);
            if(currentItem.title === userName){
                // 正在与 userName 聊天
                if(stackView.depth > 1 && (stackView.get(1).userName === userName)){
                    stackView.get(1).addMessage(message); // 直接把消息加进去
                }else{
                    if(clientMap.has(userName)){ // 如果已经有对 userName 的缓存消息
                        var msg = clientMap.get(userName);
                        msg += "\n" + message; // 在之前的基础上添加
                        clientMap.set(userName, msg);
                    }else{
                        clientMap.set(userName, message);
                    }
                    var messageNumber = clientMap.getNumber(userName); // userName 的缓存消息数量
                    console.log("cache: " + messageNumber);
                    console.log("index: " + i);
                    clientListView.model.setProperty(i, "numberValue", messageNumber.toString()); // 更新消息提醒
                }
            }
        }
    }
}
