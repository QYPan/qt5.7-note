#ifndef MYTCPSOCKET_H
#define MYTCPSOCKET_H

#include <QTcpSocket>

class MyTcpSocket : public QTcpSocket{
    Q_OBJECT
public:
    explicit MyTcpSocket(QObject *parent = 0, int clientID = 0);
    int getClientID() {return clientID;}
signals:
    void clientReadData(MyTcpSocket *socket);
    void clientDisConnect(MyTcpSocket *socket);
private slots:
    void myReadData();
    void myDisConnect();
private:
    int clientID;
};

#endif // MYTCPSOCKET_H
