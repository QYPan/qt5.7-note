#ifndef MYTCPSERVER_H
#define MYTCPSERVER_H

#include <QTcpServer>
#include <QMap>
#include <QString>
#include "clientmessage.h"
#include "mytcpsocket.h"

class MyTcpServer : public QTcpServer{
    Q_OBJECT
public:
    explicit MyTcpServer(QObject *parent = 0);
    //void sendData(ClientMsg msg, QByteArray data);
    void sendData(MyTcpSocket *socket, QByteArray data);
    void sendOfflineList(const QString &name);
    void sendClientList(MyTcpSocket *socket, const QString &name);
    void insertToMap(QString, MyTcpSocket *);
    void eraseFromMap(QString, MyTcpSocket *);
protected:
    void incomingConnection(int handle);
    QMap<QString, MyTcpSocket *> qmSocketMap;
    QMap<MyTcpSocket *, QString> mqSocketMap;
signals:
    void clientReadData(MyTcpSocket *socket);
    void clientConnect(QString name);
    void clientDisConnect(QString name);
private slots:
    void readData(MyTcpSocket *socket);
    void disConnect(MyTcpSocket *socket);
};

#endif // MYTCPSERVER_H
