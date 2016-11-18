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

void MyTcpServer::insertToMap(QString data, MyTcpSocket *socket){
    qmSocketMap.insert(data, socket);
    mqSocketMap.insert(socket, data);
}

void MyTcpServer::eraseFromMap(QString data, MyTcpSocket *socket){
    qmSocketMap.erase(qmSocketMap.find(data));
    mqSocketMap.erase(mqSocketMap.find(socket));
}

void MyTcpServer::readData(MyTcpSocket *socket){
    QString buffer = socket->readAll().data();
    QString markType = buffer.split("#")[0]; // 信息标志
    QString data = buffer.split("#")[1]; // 信息内容
    if(markType == QString("LOGIN_REQUEST")){ // 登录请求
        QMap<QString, MyTcpSocket *>::const_iterator it = qmSocketMap.find(data);
        if(it == qmSocketMap.end()){ // 请求合理
            insertToMap(data, socket);
            emit clientConnect(data);
            socket->write(tr("LOGIN_SUCCESS#%1").arg(data).toUtf8());
        }
        else{ // 用户名已存在
            socket->write(tr("LOGIN_FAILURE#%1").arg(data).toUtf8());
        }
    }
    else if(markType == QString("GET_FRIENDS_LIST_REQUEST")){ // 获取好友请求
        sendClientList(socket, data);
    }
    else if(markType == QString("SEND_TO_FRIEND")){ // 转发请求
        QString dataToFriend = buffer.split("#")[2]; // 信息内容
        QString msg = tr("RECEIVE_FROM_FRIEND#%1#%2")
                        .arg(mqSocketMap[socket]).arg(dataToFriend);
        if(qmSocketMap.find(data) != qmSocketMap.end()) // 对方在线
            qmSocketMap[data]->write(msg.toUtf8());
    }
}

void MyTcpServer::sendClientList(MyTcpSocket *socket, const QString &name){
    QString data = "";
    QMap<QString, MyTcpSocket *>::const_iterator it;
    for(it = qmSocketMap.begin(); it != qmSocketMap.end(); it++){
        if(it.key() != name){
            QString msg = "GET_FRIENDS_LIST_SUCCESS#";
            msg.append(name);
            it.value()->write(msg.toUtf8()); // 向其他已在线用户发送新用户信息
        }
        data.append(it.key());
        data.append(QString(":"));
    }
    QString buffer = "GET_FRIENDS_LIST_SUCCESS#";
    buffer.append(data);
    socket->write(buffer.toUtf8()); // 把所有在线用户写回给发出请求的用户
}

void MyTcpServer::sendOfflineList(const QString &name){
    QMap<QString, MyTcpSocket *>::const_iterator it;
    for(it = qmSocketMap.begin(); it != qmSocketMap.end(); it++){
        QString msg = "OFFLINE_REQUEST#";
        msg.append(name);
        it.value()->write(msg.toUtf8()); // 向其他已在线用户发送下线用户信息
    }
}

void MyTcpServer::disConnect(MyTcpSocket *socket){
    QMap<MyTcpSocket *, QString>::const_iterator it = mqSocketMap.find(socket);
    if(it != mqSocketMap.end()){ // 如果用户已经登录
        QString name = mqSocketMap[socket];
        emit clientDisConnect(name);
        eraseFromMap(name, socket);
        sendOfflineList(name);
    }
}

void MyTcpServer::sendData(MyTcpSocket *socket, QByteArray data){
    socket->write(data);
}
