#include "singletcpserver.h"
#include "datastruct.h"
#include "clientsocket.h"
#include <QDebug>
#include <QThread>

SingleTcpServer::SingleTcpServer(QObject *parent)
    : QTcpServer(parent)
{

}

void SingleTcpServer::incomingConnection(qintptr socketDescriptor)
{
    //qDebug() << "main thread id: " << QThread::currentThreadId();
    ClientSocket *tcpSocket = new ClientSocket(socketDescriptor);
    if(!tcpSocket->setSocketDescriptor(socketDescriptor)){
        displayError(tcpSocket->error(), tcpSocket->errorString());
        return;
    }
    //QThread *thread = new QThread;
    connect(tcpSocket, &ClientSocket::readDataSignal, this, &SingleTcpServer::readDataSlot);
    connect(tcpSocket, &ClientSocket::disconnectSignal, this, &SingleTcpServer::disconnectSlot);
    //connect(tcpSocket, &ClientSocket::disconnected, thread, &QThread::quit);
    //connect(thread, &ClientThread::sendDataSignal, tcpSocket, &ClientSocket::sendDataSlot);
    //connect(this, &SingleTcpServer::sendDataSignal, tcpSocket, &ClientSocket::sendDataSlot);
    //tcpSocket->moveToThread(thread);
    //thread->start();
}

void SingleTcpServer::readDataSlot(const DataStruct &data){
    /*
    qDebug() << data.name;
    qDebug() << data.ip;
    qDebug() << data.port;
    qDebug() << data.mark;
    qDebug() << data.message;
    */
    switch(data.mark){
        case LOGIN: tryLogin(data.name, data.socket); break;
        case ADD_ALL: tryAddAll(data.name, data.socket); break;
        case TRANSPOND: tryTranspond(data.name, data.message); break;
    }
}

bool SingleTcpServer::tryTranspond(const QString &name, const QString &message){
    QString oppName = message.split("#")[0]; // name 要传消息给 oppName
    QString oppMessage = message.mid(oppName.length()+1);
    QMap<QString, ClientSocket *>::iterator it = mapToClientSocket.find(oppName);
    if(it != mapToClientSocket.end()){ // 对方在线
        DataStruct data;
        data.name = oppName;
        data.mark = TRANSPOND_SUCCESSED;
        data.message = name + "#" + oppMessage;
        emit it.value()->sendDataSignal(data);
        return true;
    }
    return false;
}

bool SingleTcpServer::tryAddAll(const QString &name, ClientSocket *socket){
    bool ok = true;
    QMap<QString, ClientSocket *>::iterator it = mapToClientSocket.begin();
    DataStruct data;
    data.name = name;
    for(; it != mapToClientSocket.end(); it++){
        if(it.key() != name){
            DataStruct sub;
            sub.name = it.key();
            sub.mark = ADD_SUCCESSED;
            sub.message = name;
            emit it.value()->sendDataSignal(sub); // 向其他用户发送新用户信息
        }
        data.message += it.key(); // 向新用户添加其他用户信息
        if(it+1 != mapToClientSocket.end())
            data.message += "#";
    }
    data.mark = ADD_SUCCESSED;
    emit socket->sendDataSignal(data);
    return ok;
}

bool SingleTcpServer::tryLogin(const QString &name, ClientSocket *socket){
    bool ok = true;
    QMap<QString, ClientSocket *>::iterator it = mapToClientSocket.find(name);
    DataStruct data;
    data.name = name;
    if(it == mapToClientSocket.end()){
        addClientToMap(name, socket);
        socket->setClientName(name);
        data.mark = LOGIN_SUCCESSED;
        data.message = "login successed";
    }else{
        data.mark = LOGIN_FAILURE;
        data.message = "login failure";
        ok = false;
    }
    emit socket->sendDataSignal(data);
    return ok;
}

void SingleTcpServer::disconnectSlot(const DataStruct &data){
    removeClientFromMap(data.name);
    QMap<QString, ClientSocket *>::iterator it = mapToClientSocket.begin();
    for(; it != mapToClientSocket.end(); it++){
        DataStruct sendData;
        sendData.name = it.key();
        sendData.mark = data.mark;
        sendData.message = data.name;
        emit it.value()->sendDataSignal(sendData);
    }
}

void SingleTcpServer::addClientToMap(const QString &name, ClientSocket *socket){
    mapToClientSocket.insert(name, socket);
    qDebug() << name << " online";
}

void SingleTcpServer::removeClientFromMap(const QString &name){
    mapToClientSocket.erase(mapToClientSocket.find(name));
    qDebug() << name << " offline";
}

void SingleTcpServer::displayError(int socketError, const QString &message){
    qDebug() << socketError << " error: " << message;
}
