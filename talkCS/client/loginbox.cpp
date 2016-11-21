#include "loginbox.h"
#include "myhelper.h"
#include <QTcpSocket>
#include <QMessageBox>
#include <QListWidget>
#include <QHBoxLayout>
#include <QFont>
#include <QGridLayout>
#include <QHostAddress>
#include <QHostInfo>
#include <QPushButton>
#include <QVBoxLayout>
#include <QSPinBox>
#include <QLabel>
#include <QLineEdit>

LoginBox::LoginBox(QWidget *parent)
: QWidget(parent)
{
    this->init();
}

void LoginBox::init(){
    resize(300, 200);
    FormHelper::formNotResize(this);
    FormHelper::setWinBackground(this, QPixmap(":/images/loginbackground"));

    clientSocket = new QTcpSocket(this);
    clientSocket->abort();
    connect(clientSocket, &QTcpSocket::readyRead, this, &LoginBox::readData);
    connect(clientSocket, &QTcpSocket::readyRead, this, &LoginBox::readData);
    // 无法连接服务器时没有触发 QAbstractSocket::error() 信号，尚不清楚原因，Linux 下可以正常触发
#if 1
    typedef void (QAbstractSocket::*QAbstractSocketErrorSignal)(QAbstractSocket::SocketError);
    connect(clientSocket, static_cast<QAbstractSocketErrorSignal>(&QAbstractSocket::error),
            this, &LoginBox::readError);
#endif

    QLabel *loginLabel = new QLabel(tr("登录"));
    QFont ft;
    ft.setPointSize(25);
    loginLabel->setFont(ft);

    QGridLayout *centerLayout = addCenterLayout();

    // ---------------------------------------------------
    connectButton = new QPushButton(tr("连接"));
    connect(connectButton, &QPushButton::clicked, this, &LoginBox::connectButtonClicked);

    // ---------------------------------------------------
    QVBoxLayout *mainLayout = new QVBoxLayout;
    //mainLayout->addSpacing(40);
    mainLayout->addWidget(loginLabel, 0, Qt::AlignHCenter);
    mainLayout->addLayout(centerLayout);
    mainLayout->addWidget(connectButton);

    setLayout(mainLayout);
}

QGridLayout *LoginBox::addCenterLayout(){
    // ---------------------------------------------------
    QLabel *nameLabel = new QLabel(tr("姓        名："));
    nameEdit = new QLineEdit;
    nameEdit->setMaxLength(15);
    nameLabel->setBuddy(nameEdit);
    QHBoxLayout *nameLayout = new QHBoxLayout;
    nameLayout->addWidget(nameLabel);
    nameLayout->addWidget(nameEdit);

    connect(nameEdit, &QLineEdit::returnPressed, this, &LoginBox::connectButtonClicked);

    // ---------------------------------------------------
    QLabel *ipLabel = new QLabel(tr("服务器ip地址："));
    ipEdit = new QLineEdit;
    ipEdit->setText(getLocalHostIpAddress());
    ipLabel->setBuddy(ipEdit);

    // ---------------------------------------------------
    QLabel *portLabel = new QLabel(tr("服务器端口号："));
    portBox = new QSpinBox;
    portBox->setRange(1001, 65534);
    portBox->setValue(60000);
    portLabel->setBuddy(portBox);

    // ---------------------------------------------------
    QGridLayout *layout = new QGridLayout;
    layout->addWidget(nameLabel, 0, 0, Qt::AlignRight);
    layout->addWidget(nameEdit, 0, 1);
    layout->addWidget(ipLabel, 1, 0, Qt::AlignRight);
    layout->addWidget(ipEdit, 1, 1);
    layout->addWidget(portLabel, 2, 0, Qt::AlignRight);
    layout->addWidget(portBox, 2, 1);

    return layout;
}

QString LoginBox::getLocalHostIpAddress(){
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

void LoginBox::readError(QAbstractSocket::SocketError){
    clientSocket->disconnectFromHost();
    connectButton->setText("连接");
    QMessageBox msg(this);
    msg.setText(tr("连接服务器失败，原因：%1")
                .arg(clientSocket->errorString()));
    msg.exec();
}

void LoginBox::getFriendsList(){ // 获取好友列表（实际是所有在线用户列表）
    clientSocket->write(tr("GET_FRIENDS_LIST_REQUEST#%1").arg(userName).toUtf8());
}

void LoginBox::addFriendToList(const QString &data){
    QStringList friendList = data.split(':');
    for(int i = 0; i < friendList.size(); i++){
        QString name = friendList.at(i);
        if(name != ""){
            fm->friendLists->addItem(name);
            fm->onlineJudge(true);
        }
    }
}

void LoginBox::readData(){
    QString buffer = clientSocket->readAll().data();
    QString markType = buffer.split('#')[0]; // 标志
    QString data = buffer.split('#')[1]; // 内容
    if(markType == QString("LOGIN_FAILURE")){
        QMessageBox msg(this);
        msg.setText(tr("%1 已存在！").arg(data));
        msg.exec();
    }
    else if(markType == QString("LOGIN_SUCCESS")){
        connectButton->setText("...");
        connectButton->setEnabled(false);
        userName = data;
        fm = new FrmMain(data);
        getFriendsList();
        connect(fm, &FrmMain::sendMessageToFriend, this, &LoginBox::sendData);
        fm->show(); // 打开用户窗口
        this->close();
    }
    else if(markType == QString("GET_FRIENDS_LIST_SUCCESS")){
        addFriendToList(data);
    }
    else if(markType == QString("OFFLINE_REQUEST")){ // 有用户下线
        eraseFriendFromList(data);
    }
    else if(markType == QString("RECEIVE_FROM_FRIEND")){
        QString message = buffer.split('#')[2];
        fm->receiveFromFriend(data, message);
    }
}

void LoginBox::sendData(QByteArray data){
    clientSocket->write(data);
}

void LoginBox::eraseFriendFromList(const QString &name){
    QList<QListWidgetItem *> nameList =
            fm->friendLists->findItems(name, Qt::MatchStartsWith);
    fm->friendLists->takeItem(fm->friendLists->row(nameList.first()));
    fm->tryDeleteTalkWin(name);
    fm->onlineJudge(false);
}

void LoginBox::sendLoginMessage(){
    QString name = nameEdit->text();
    if(!name.isEmpty()){
        QString msg = QString("LOGIN_REQUEST") + "#" + name;
        clientSocket->write(msg.toUtf8());
    }
    else{
        QMessageBox msg(this);
        msg.setText("请先输入用户名后再连接！");
        msg.exec();
    }
}

void LoginBox::connectButtonClicked(){
    if(clientSocket->state() == QAbstractSocket::UnconnectedState){ // 连接尚未建立
        clientSocket->connectToHost(ipEdit->text(), portBox->value());
        if(clientSocket->waitForConnected(1000)){
            ipEdit->setEnabled(false);
            portBox->setEnabled(false);
            sendLoginMessage();
        }
        else{ // 无法连接服务器，手动断开
            clientSocket->disconnectFromHost();
            connectButton->setText("连接");
            connectButton->setEnabled(true);
            QMessageBox msg(this);
            msg.setText("连接失败！");
            msg.exec();
        }
    }
    else{
        sendLoginMessage();
    }
}
