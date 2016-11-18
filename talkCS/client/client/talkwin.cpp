#include "talkwin.h"
#include "myhelper.h"
#include <QLineEdit>
#include <QCloseEvent>
#include <QTextEdit>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QLabel>

TalkWin::TalkWin(const QString name, QWidget *parent)
: QDialog(parent), friendName(name)
{
    this->init();
}

void TalkWin::init(){
    resize(400, 300);
    FormHelper::formNotResize(this);
    textReceive = new QTextEdit;
    textReceive->setReadOnly(true);

    QLabel *msgLabel = new QLabel(tr("消息："));
    messageEdit = new QLineEdit;
    msgLabel->setBuddy(messageEdit);
    QHBoxLayout *msgLayout = new QHBoxLayout;
    sendButton = new QPushButton(tr("发送"));
    msgLayout->addWidget(msgLabel);
    msgLayout->addWidget(messageEdit);
    msgLayout->addWidget(sendButton);

    connect(sendButton, &QPushButton::clicked, this, &TalkWin::sendButtonClicked);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addWidget(textReceive);
    mainLayout->addLayout(msgLayout);

    setLayout(mainLayout);
    setWindowTitle(friendName);
}

void TalkWin::Destroy(){
    this->destroy();
}

void TalkWin::closeEvent(QCloseEvent *event){
    emit readyToClose(friendName);
    QDialog::closeEvent(event);
}

void TalkWin::sendButtonClicked(){
    QString message = messageEdit->text();
    messageEdit->clear();
    if(message != ""){
        textReceive->append(tr("me: %1").arg(message));
        QString data = tr("SEND_TO_FRIEND#%1#%2").arg(friendName).arg(message);
        emit sendData(data.toUtf8());
    }
}
