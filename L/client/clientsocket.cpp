#include "clientsocket.h"
#include <QHostAddress>
#include <QHostInfo>
#include <QVBoxLayout>
#include <QDebug>

ClientSocket::ClientSocket(QObject *parent)
    : QObject(parent)
{
    this->init();
}


QString ClientSocket::clientName() const{
    return m_clientName;
}

void ClientSocket::setClientName(const QString &newName){
    m_clientName = newName;
}

void ClientSocket::sendDataSlot(const QString &message){
    QString buffer = m_clientName + "#" + QString(QChar(TRANSPOND+'0')) + "#" + message;
    tcpSocket.write(buffer.toUtf8());
}

void ClientSocket::getUsersSlot(){
    DataStruct data;
    data.name = m_clientName;
    data.mark = ADD_ALL;
    qDebug() << data.mark;
    QString buffer = data.name + "#" + QString(QChar(data.mark+'0')) + "#" + data.message;
    tcpSocket.write(buffer.toUtf8());
}

void ClientSocket::init(){
    tcpSocket.abort();
    connect(&tcpSocket, &QTcpSocket::readyRead, this, &ClientSocket::readDataSlot);
    connect(this, &ClientSocket::connectSignal, this, &ClientSocket::connectButtonClicked);
    connect(this, &ClientSocket::getUsersSignal, this, &ClientSocket::getUsersSlot);
    connect(this, &ClientSocket::sendDataSignal, this, &ClientSocket::sendDataSlot);
}

QString ClientSocket::getLocalHostIpAddress(){
    QString ip;
    QString localHostName = QHostInfo::localHostName();
    QHostInfo info = QHostInfo::fromName(localHostName);
    foreach(QHostAddress address, info.addresses()){
        if(address.protocol() == QAbstractSocket::IPv4Protocol){
            ip = address.toString();
            break;
        }
    }
    if(ip.isEmpty())
        ip = QHostAddress(QHostAddress::LocalHost).toString();
    return ip;
}

void ClientSocket::readDataSlot(){
    QString buffer = tcpSocket.readAll();
    emit readDataSignal(buffer);
}

void ClientSocket::sendLoginMessage(const QString &name){
    DataStruct data;
    data.name = name;
    data.mark = LOGIN;
    QString buffer = data.name + "#" + QString(QChar(data.mark+'0')) + "#" + data.message;
    tcpSocket.write(buffer.toUtf8());
}

void ClientSocket::connectButtonClicked(const QString &name){
    if(tcpSocket.state() == QAbstractSocket::UnconnectedState){ // 连接尚未建立
        //tcpSocket.connectToHost(getLocalHostIpAddress(), 60000);
        tcpSocket.connectToHost("192.168.191.1", 60000);
        if(tcpSocket.waitForConnected(5000)){
            sendLoginMessage(name);
        }
        else{ // 无法连接服务器，手动断开
            tcpSocket.disconnectFromHost();
            emit displayConnectError(tcpSocket.error(), tcpSocket.errorString());
        }
    }
    else{
        sendLoginMessage(name);
    }
}
