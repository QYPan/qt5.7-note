#include "mytcpserver.h"
#include <QHostAddress>
#include <QDebug>

MyTcpServer::
MyTcpServer(QObject *parent)
: QTcpServer(parent)
{
}

void MyTcpServer::
incomingConnection(int handle){
    MyTcpSocket *client = new MyTcpSocket(this, handle); // 新客户端接入
    client->setSocketDescriptor(handle);

    connect(client, &MyTcpSocket::clientReadData,
            this, &MyTcpServer::readData);
    connect(client, &MyTcpSocket::clientDisConnect,
            this, &MyTcpServer::disConnect);
}

void MyTcpServer::insertToMap(QString data, int id){
    siSocketMap.insert(data, id);
    isSocketMap.insert(id, data);
}

void MyTcpServer::eraseFromMap(QString data, int id){
    siSocketMap.erase(siSocketMap.find(data));
    isSocketMap.erase(isSocketMap.find(id));
}

void MyTcpServer::readData(MyTcpSocket *socket){
    QString buffer = socket->readAll().data();
    QString markType = buffer.split("#")[0]; // 信息标志
    QString data = buffer.split("#")[1]; // 信息内容
    if(markType == QString("LOGIN_REQUEST")){ // 登录请求
        QMap<QString, int>::const_iterator it = siSocketMap.find(data);
        if(it == siSocketMap.end()){ // 请求合理
            insertToMap(data, socket->getClientID());
            emit clientConnect(data);
            socket->write(tr("LOGIN_SUCCESS#%1").arg(data).toUtf8());
        }
        else{ // 用户名已存在
            socket->write(tr("LOGIN_FAILURE#%1").arg(data).toUtf8());
        }
    }
    else if(markType == QString("GET_FRIENDS_LIST_REQUEST")){ // 获取好友请求
        sendClientList(socket);
    }
}

void MyTcpServer::sendClientList(MyTcpSocket *socket){
    QString data = "";
    QMap<QString, int>::const_iterator it;
    for(it = siSocketMap.begin(); it != siSocketMap.end(); it++){
        data.append(it.key());
        data.append(QString(":"));
    }
    QString buffer("GET_FRIENDS_LIST_SUCCESS#");
    buffer.append(data);
    socket->write(buffer.toUtf8());
}

void MyTcpServer::disConnect(MyTcpSocket *socket){
    int id = socket->getClientID();
    QMap<int, QString>::const_iterator it = isSocketMap.find(id);
    if(it != isSocketMap.end()){ // 如果用户已经登录
        QString data = isSocketMap[id];
        emit clientDisConnect(data);
        eraseFromMap(data, id);
    }
}

void MyTcpServer::sendData(MyTcpSocket *socket, QByteArray data){
    socket->write(data);
}
