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
                var obj = Qt.createComponent("TalkPage.qml");
                if(obj.status === Component.Ready){
                    var item = obj.createObject();
                    item.userName = title;
                    item.sendMessage.connect(sendData);
                    if(clientMap.has(title)){
                        item.addMessage(clientMap.get(title));
                        clientMap.clear(title);
                    }
                    client.ListView.view.currentIndex = index;
                    stackView.push(item);
                }
            }
            function sendData(message){
                var newMessage = title + "#";
                newMessage += message;
                socket.sendDataSignal(newMessage);
            }
        }
    }
    function addOne(userName){
        clientListView.model.append({"title" : userName, "numberValue" : ""});
    }
    function removeOne(userName){
        var i;
        for(i = 0; i < clientListView.count; i++){
            var currentItem = clientListView.model.get(i);
            if(currentItem.title === userName){
                clientListView.model.remove(i);
                if(clientListView.currentIndex === i){
                    stackView.pop();
                }
            }
        }
    }
    function receiveMessage(userName, message){
        var i;
        for(i = 0; i < clientListView.count; i++){
            var currentItem = clientListView.model.get(i);
            if(currentItem.title === userName){
                if(stackView.depth > 1 && (stackView.get(1).userName === userName)){
                    stackView.get(1).addMessage(message);
                }else{
                    if(clientMap.has(userName)){
                        var msg = clientMap.get(userName);
                        msg += "\n" + message;
                        clientMap.set(userName, msg);
                    }else{
                        clientMap.set(userName, message);
                    }
                    var tmp = clientMap.getNumber(userName);
                    clientListView.model.setProperty(i, "numberValue", tmp.toString());
                }
            }
        }
    }
}
