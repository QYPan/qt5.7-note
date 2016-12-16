#ifndef SINGLETCPSERVER_H
#define SINGLETCPSERVER_H

#include <QTcpServer>
#include <QMap>
#include "clientsocket.h"
#include "datastruct.h"

class SingleTcpServer : public QTcpServer
{
    Q_OBJECT
public:
    SingleTcpServer(QObject *parent = 0);
    void addClientToMap(const QString &name, ClientSocket *socket);
    void removeClientFromMap(const QString &name);
signals:
    void sendDataSignal(const DataStruct &data);
private slots:
    void readDataSlot(const DataStruct &data);
    void disconnectSlot(const DataStruct &data);
    void displayError(int socketError, const QString &message);
protected:
    void incomingConnection(int socketDescriptor);
private:
    bool tryLogin(const QString &name, ClientSocket *socket);
    bool tryAddAll(const QString &name, ClientSocket *socket);
    bool tryTranspond(const QString &name, const QString &message);
    QMap<QString, ClientSocket *> mapToClientSocket;
};

#endif // SINGLETCPSERVER_H
