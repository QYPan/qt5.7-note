#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include "socketthread.h"
#include "datastruct.h"

class QmlInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString clientName READ clientName WRITE setClientName)
    Q_ENUMS(MessageType)
public:
    Q_INVOKABLE void qmlSendData(int type, const QString &message);
    Q_INVOKABLE void tryConnect();
    enum MessageType {LOGIN, ADD_ONE, ADD_ALL, TRANSPOND
                      , ADD_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED
                      , OFFLINE, TRANSPOND_SUCCESSED};
    QmlInterface(QObject *parent = 0);
    QString clientName() const;
    void setClientName(const QString &name);
    void createSocketThread();
signals:
    void displayError(int socketError, const QString &message);
    void qmlReadData(int type, const QString &message);
    void sendData(const DataStruct &data);
public slots:
    void readData(const DataStruct &data);
    void tryLogin();
private:
    SocketThread *thread;
    QString m_name;
};

#endif // QMLINTERFACE_H
