#include "qmlinterface.h"
#include <QDebug>

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , thread(NULL)
{
    qRegisterMetaType<DataStruct>("DataStruct");
    createSocketThread();
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    //connect(thread, &SocketThread::finished, thread, &SocketThread::deleteLater);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::tryLogin);
}

void QmlInterface::tryConnect(){
    if(!thread->tryConnect()){ // 已经连接了
        tryLogin(); // 尝试登陆
    }
}

void QmlInterface::tryLogin(){
    qmlSendData(LOGIN, "");
}

void QmlInterface::qmlSendData(int type, const QString &message){
    DataStruct data;
    data.name = m_name;
    data.mark = type;
    data.message = message;
    qDebug() << m_name << " try to send data";
    emit sendData(data);
}

QString QmlInterface::clientName() const{
    return m_name;
}
void QmlInterface::setClientName(const QString &name){
    m_name = name;
}

void QmlInterface::readData(const DataStruct &data){
    emit qmlReadData(data.mark, data.message);
}
