#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H

#include <QTcpSocket>
#include "datastruct.h"

class ClientSocket : public QTcpSocket
{
    Q_OBJECT
public:
    ClientSocket(int socketDescriptor, QObject *parent = 0);
    QString getClientName(){return clientName;}
    void setClientName(const QString &newName) {clientName = newName;}
signals:
    void sendDataSignal(const DataStruct &data);
    void readDataSignal(const DataStruct &data);
    void disconnectSignal(const DataStruct &data);
public slots:
    void sendDataSlot(const DataStruct &data);
private slots:
    void readDataFromSocket();
    void disconnectSlot();
private:
    void resolve(const QString &buffer);
    void merge(const DataStruct &data);
    QString clientName;
    int m_socketDescriptor;
};

#endif // CLIENTSOCKET_H
