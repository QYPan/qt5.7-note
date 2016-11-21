#include "frmmain.h"
#include "myhelper.h"
#include <QListWidget>
#include <QHostAddress>
#include <QHostInfo>
#include <QPushButton>
#include <QHBOXLayout>
#include <QVBOXLayout>
#include <QLabel>
#include <QLineEdit>
#include <QSpinBox>
#include <QDebug>

FrmMain::
FrmMain(QWidget *parent)
: QWidget(parent)
{
    this->init();
}

void FrmMain::
init(){
    server = new MyTcpServer(this);

    resize(300, 500);
    FormHelper::formNotResize(this);
    clientLists = new QListWidget;

    // ----------------------------------------------
    QLabel *ipLabel = new QLabel(tr("ip 地址："));
    ipEdit = new QLineEdit;
    ipEdit->setText(getLocalHostIpAddress());
    //ipEdit->setReadOnly(true);
    ipLabel->setBuddy(ipEdit);
    QHBoxLayout *ipLayout = new QHBoxLayout;
    ipLayout->addWidget(ipLabel);
    ipLayout->addWidget(ipEdit);

    // ----------------------------------------------
    QLabel *portLabel = new QLabel(tr("端口："));
    portNumber = new QSpinBox;
    portNumber->setRange(1001, 65534);
    portNumber->setValue(60000);
    portLabel->setBuddy(portNumber);
    QHBoxLayout *portLayout = new QHBoxLayout;
    portLayout->addWidget(portLabel);
    portLayout->addWidget(portNumber);

    // ----------------------------------------------
    listenButton = new QPushButton(tr("监听"));

    // ----------------------------------------------
    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addWidget(clientLists);
    mainLayout->addLayout(ipLayout);
    mainLayout->addLayout(portLayout);
    mainLayout->addWidget(listenButton);

    setLayout(mainLayout);

    connect(server, &MyTcpServer::clientConnect, this, &FrmMain::clientConnect);
    connect(server, &MyTcpServer::clientDisConnect, this, &FrmMain::clientDisConnect);
    connect(listenButton, &QPushButton::clicked, this, &FrmMain::listenButtonClicked);
}

QString FrmMain::getLocalHostIpAddress(){
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

void FrmMain::clientConnect(QString name){
    clientLists->addItem(name);
}

void FrmMain::clientDisConnect(QString name){
    QList<QListWidgetItem *> items = clientLists->findItems(name, Qt::MatchStartsWith);
    clientLists->takeItem(clientLists->row(items.first()));
}

void FrmMain::listenButtonClicked(){
    if(listenButton->text() == "监听"){
        bool ok = server->listen(QHostAddress::Any, portNumber->text().toInt());
        if(ok){
            ipEdit->setEnabled(false);
            portNumber->setEnabled(false);
            listenButton->setText(tr("停止"));
        }
    }
    else{
        server->close();
        listenButton->setText(tr("监听"));
        ipEdit->setEnabled(true);
        portNumber->setEnabled(true);
    }
}
