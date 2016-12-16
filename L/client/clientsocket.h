#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H

#include <QObject>
#include <QTcpSocket>

class QLineEdit;

class ClientSocket : public QObject
{
    Q_OBJECT
    Q_ENUMS(MessageType)
    Q_PROPERTY(QString clientName READ clientName WRITE setClientName)
public:
    ClientSocket(QObject *parent = 0);
    enum MessageType {LOGIN, ADD_ONE, ADD_ALL, TRANSPOND
                      , ADD_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED
                      , OFFLINE, TRANSPOND_SUCCESSED};
    struct DataStruct
    {
        DataStruct()
            : message("")
            , name("")
            , ip("")
        {}
        QString message;
        QString name;
        QString ip;
        int port;
        MessageType mark;
        ClientSocket *socket;
    };
    QString clientName() const;
    void setClientName(const QString &newName);
signals:
    void displayConnectError(int socketError, const QString &message);
    void connectSignal(const QString &name);
    void getUsersSignal();
    void sendDataSignal(const QString &message);
    void readDataSignal(const QString &data);
private slots:
    void connectButtonClicked(const QString &name);
    void getUsersSlot();
    void sendDataSlot(const QString &message);
    void readDataSlot();
private:
    void init();
    void sendLoginMessage(const QString &name);
    QString getLocalHostIpAddress();
    QString m_clientName;
    QTcpSocket tcpSocket;
    QLineEdit *lineEdit;
};

#endif // CLIENTSOCKET_H
