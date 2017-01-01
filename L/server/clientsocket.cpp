#include "clientsocket.h"
#include <QHostAddress>
#include <QAbstractSocket>
#include <QDebug>
#include <QThread>

ClientSocket::ClientSocket(int socketDescriptor, QObject *parent)
    : QTcpSocket(parent)
    , m_socketDescriptor(socketDescriptor)
{
    connect(this, &ClientSocket::readyRead, this, &ClientSocket::readDataFromSocket);
    connect(this, &ClientSocket::sendDataSignal, this, &ClientSocket::sendDataSlot);
    connect(this, &ClientSocket::disconnected, this, &ClientSocket::disconnectSlot);
    connect(this, &ClientSocket::disconnected, this, &ClientSocket::deleteLater);
}

void ClientSocket::sendDataSlot(const DataStruct &data){
    merge(data);
}

void ClientSocket::readDataFromSocket(){
    //qDebug() << "socket thread id: " << QThread::currentThreadId();
    QString buffer = readAll().data();
    resolve(buffer);
}

void splitString(const QString &str, int k, QString &sub){
    int count = 0;
    int beg = 0;
    for(int i= 0; i < str.size(); i++){
        if(str[i] == '#' || i == str.size()-1){
            if(count == k){
                sub = str.mid(beg, i-beg);
                return;
            }
            else{
                beg = i + 1;
                count++;
                if(count == 2)
                    break;
            }
        }
    }
    if(beg == str.size()) sub = "";
    else sub = str.mid(beg);
}

void ClientSocket::disconnectSlot(){
    DataStruct data;
    data.name = clientName;
    data.mark = OFFLINE;
    emit disconnectSignal(data);
}

// 合并数据并且发出去
void ClientSocket::merge(const DataStruct &data){
    QString name = data.name;
    QString mark = QString(QChar(data.mark+'0'));
    QString message = data.message;
    QString all = name + "#" + mark + "#" + message;
    write(all.toUtf8());
}

// 分解数据并且发给主线程
void ClientSocket::resolve(const QString &buffer){
    DataStruct data;
    QString mark;
    splitString(buffer, 0, data.name);
    splitString(buffer, 1, mark);
    splitString(buffer, 2, data.message);
    qDebug() << "buffer: " << buffer;
    qDebug() << "in socket name: " << data.name;
    qDebug() << "in socket mark: " << mark;
    qDebug() << "in socket mesa: " << data.message;
    data.mark = static_cast<MessageType>(mark.toInt());
    data.ip = peerAddress().toString();
    data.port = peerPort();
    data.socket = this;
    emit readDataSignal(data);
}
