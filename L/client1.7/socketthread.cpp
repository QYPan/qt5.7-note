#include "socketthread.h"
#include "clientsocket.h"
#include "datastruct.h"
#include "qmlinterface.h"
#include <QTcpSocket>
#include <QDebug>

SocketThread::SocketThread(QObject *parent)
    : m_receiver(parent)
{
    qRegisterMetaType<DataStruct>("DataStruct");
}

bool SocketThread::tryConnect(){
    if(!isRunning()){
        start();
        return true;
    }
    return false;
}

void SocketThread::run(){
    const int timeOut = 5 * 1000;
    ClientSocket socket;
    //socket.connectToHost("118.89.35.51", 60000);
    socket.connectToHost("172.18.120.12", 9734);
    if (!socket.waitForConnected(timeOut)) {
        emit error(socket.error(), socket.errorString());
        return;
    }
    qDebug() << "connect successed!";
    emit connectSuccessed();
    connect(&socket, SIGNAL(getError(int,QString)), m_receiver.data(), SIGNAL(displayError(int,QString)));
    connect(&socket, SIGNAL(readData(DataStruct)), m_receiver.data(), SLOT(readData(DataStruct)));
    connect(m_receiver.data(), SIGNAL(sendData(DataStruct)), &socket, SLOT(sendData(DataStruct)));
    /*
    connect(&socket, &ClientSocket::getError, m_receiver.data(), &QmlInterface::error);
    connect(&socket, &ClientSocket::readData, m_receiver.data(), &QmlInterface::readData);
    connect(m_receiver.data(), &QmlInterface::sendData, &socket, &ClientSocket::sendData);
    */
    exec();
}
