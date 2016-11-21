#include "frmmain.h"
#include "myhelper.h"
#include <QTcpSocket>
#include <QStringList>
#include <QListWidget>
#include <QGroupBox>
#include <QBrush>
#include <QPixmap>
#include <QColor>
#include <QListWidgetItem>
#include <QTextEdit>
#include <QVBoxLayout>
#include <QMessageBox>
#include <QDebug>

FrmMain::FrmMain(QString name, QWidget *parent)
: QWidget(parent), userName(name), onlineNumber(0)
{
    this->init();
}

void FrmMain::init(){
    resize(300, 500);

    FormHelper::formNotResize(this);
    FormHelper::setWinBackground(this, QPixmap(":/images/listbackground"));

    friendLists = new QListWidget;
    QHBoxLayout *listLayout = new QHBoxLayout;
    listLayout->addWidget(friendLists);
    mainBox = new QGroupBox(tr("在线用户 %1 人").arg(onlineNumber));
    mainBox->setLayout(listLayout);
    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addWidget(mainBox);

    connect(friendLists, &QListWidget::itemDoubleClicked,
            this, &FrmMain::judgeState);

    setLayout(mainLayout);
    setWindowTitle(userName);
}

void FrmMain::onlineJudge(bool flag){
    if(flag){
        onlineNumber += 1;
        mainBox->setTitle(tr("在线用户 %1 人").arg(onlineNumber));
    }
    else{
        onlineNumber -= 1;
        mainBox->setTitle(tr("在线用户 %1 人").arg(onlineNumber));
    }
}

void FrmMain::emitSendSignal(QByteArray data){
    emit sendMessageToFriend(data);
}

void FrmMain::judgeState(){
    QListWidgetItem *curItem = friendLists->currentItem();
    curItem->setBackground(QBrush(QColor(Qt::white)));
    QString friendName = curItem->text();
    QMap<QString, TalkWin *>::const_iterator it =
            nameToWinMap.find(friendName);
    if(it == nameToWinMap.end()){ // 窗口还没打开
        nameToWinMap.insert(friendName, createTalkWin(friendName));
    }
    tryAddTextToTalkWin(friendName);
}

void FrmMain::receiveFromFriend(const QString &name, const QString &msg){
    QMap<QString, QStringList *>::const_iterator it = nameToDataMap.find(name);
    if(it == nameToDataMap.end()){ // 还没建立朋友 name 的消息缓存区
        QStringList *msgBuffer = new QStringList;
        QString data = "he: ";
        data.append(msg);
        (*msgBuffer) << data;
        nameToDataMap.insert(name, msgBuffer);
    }
    else{
        QString data = "he: ";
        data.append(msg);
        (*(it.value())) << data;
    }
    tryAddTextToTalkWin(name);
}

void FrmMain::tryAddTextToTalkWin(const QString &name){
    QMap<QString, TalkWin *>::const_iterator winIt = nameToWinMap.find(name);
    if(winIt != nameToWinMap.end()){ // 窗口已经打开
        QMap<QString, QStringList *>::const_iterator newIt = nameToDataMap.find(name);
        if(newIt != nameToDataMap.end()){ // 已经有消息在缓存区
            QStringList *msgList = newIt.value();
            for(int i = 0; i < msgList->size(); i++){
                winIt.value()->textReceive->append(msgList->at(i));
            }
            msgList->clear(); // 写完后清空消息缓存
        }
    }
    else{ // 提示信息
        QList<QListWidgetItem *> nameList =
                friendLists->findItems(name, Qt::MatchStartsWith);
        nameList.first()->setBackground(QBrush(QColor(23, 14, 56, 123)));
    }
}

void FrmMain::afterTalkWinClosed(QString name){
    QMap<QString, TalkWin *>::iterator winIt = nameToWinMap.find(name);
    if(winIt != nameToWinMap.end())
        nameToWinMap.erase(winIt);
    QMap<QString, QStringList *>::iterator dataIt = nameToDataMap.find(name);
    if(dataIt != nameToDataMap.end()){
        delete dataIt.value();
        nameToDataMap.erase(dataIt);
    }
}

void FrmMain::tryDeleteTalkWin(const QString &name){
    QMap<QString, TalkWin *>::iterator winIt = nameToWinMap.find(name);
    if(winIt != nameToWinMap.end())
        winIt.value()->Destroy();
    afterTalkWinClosed(name);
}

TalkWin *FrmMain::createTalkWin(const QString &friendName){
    TalkWin *talkWin = new TalkWin(userName, friendName, this);
    connect(talkWin, &TalkWin::sendData, this, &FrmMain::emitSendSignal);
    connect(talkWin, &TalkWin::readyToClose, this, &FrmMain::afterTalkWinClosed);
    talkWin->show();
    return talkWin;
}
