#ifndef FRMMAIN_H
#define FRMMAIN_H

#include <QWidget>
#include <QString>
#include <QMap>
#include <QString>
#include <QByteArray>
#include "talkwin.h"

class QListWidget;
class QTcpSocket;
class QStringList;

class FrmMain : public QWidget{
    Q_OBJECT
public:
    explicit FrmMain(QString name, QWidget *parent = 0);
    QListWidget *friendLists;
    void receiveFromFriend(const QString &name, const QString &msg);
    void tryDeleteTalkWin(const QString &name);
    void tryAddTextToTalkWin(const QString &name);
signals:
    void sendMessageToFriend(QByteArray data);
private slots:
    void judgeState();
    void afterTalkWinClosed(QString name); // const QString &name ?
    void emitSendSignal(QByteArray data);
private:
    QMap<QString, TalkWin *> nameToWinMap;
    QMap<QString, QStringList *> nameToDataMap; // 好友消息缓冲区
    QString userName;
    void init();
    TalkWin *createTalkWin(const QString &name);
};

#endif // FRMMAIN_H
