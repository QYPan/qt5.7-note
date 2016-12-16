#ifndef CLIENTLISTWIN_H
#define CLIENTLISTWIN_H

#include <QObject>
#include <QWidget>
#include "singletcpserver.h"

class ClientListWin : public QWidget
{
    Q_OBJECT
public:
    ClientListWin(QWidget *parent = 0);
    QString getLocalHostIpAddress();
private:
    SingleTcpServer tcpServer;
};

#endif // CLIENTLISTWIN_H
