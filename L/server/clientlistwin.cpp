#include <QHostInfo>
#include <QHostAddress>
#include "clientlistwin.h"
#include <QDebug>

ClientListWin::ClientListWin(QWidget *parent)
    : QWidget(parent)
{
    resize(300, 200);
    qDebug() << getLocalHostIpAddress();
    bool ok = tcpServer.listen(QHostAddress::Any, 60000);
    if(!ok){
        qDebug() << "listen failured";
    }else{
        qDebug() << "listen successed";
    }
}

QString ClientListWin::getLocalHostIpAddress(){
    QString ip;
    QString localHostName = QHostInfo::localHostName();
    QHostInfo info = QHostInfo::fromName(localHostName);
    foreach(QHostAddress address, info.addresses()){
        if(address.protocol() == QAbstractSocket::IPv4Protocol){
            ip = address.toString();
            break;
        }
    }
    if(ip.isEmpty())
        ip = QHostAddress(QHostAddress::LocalHost).toString();
    return ip;
}
