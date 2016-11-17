#include "mytcpsocket.h"
#include <QHostAddress>
#include <QDebug>

MyTcpSocket::
MyTcpSocket(QObject *parent, int clientID)
: QTcpSocket(parent)
{
    this->clientID = clientID;
    connect(this, &MyTcpSocket::readyRead, this, &MyTcpSocket::myReadData);
    connect(this, &MyTcpSocket::disconnected, this, &MyTcpSocket::myDisConnect);
    connect(this, &MyTcpSocket::disconnected, this, &MyTcpSocket::deleteLater);
}

void MyTcpSocket::
myReadData(){
    emit clientReadData(this);
}

void MyTcpSocket::
myDisConnect(){
    emit clientDisConnect(this);
}
