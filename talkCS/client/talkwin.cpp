#include "talkwin.h"
#include "myhelper.h"
#include <QLineEdit>
#include <QCloseEvent>
#include <QTextEdit>
#include <QGroupBox>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QPushButton>
#include <QLabel>

TalkWin::TalkWin(const QString _user, const QString _friend, QWidget *parent)
: QDialog(parent), userName(_user), friendName(_friend)
{
    this->init();
}

void TalkWin::init(){
    resize(400, 300);
    FormHelper::formNotResize(this);
    FormHelper::setWinBackground(this, QPixmap(":/images/talkbackground"));
    //FormHelper::addMinimizeButtonHint(this);

    QGroupBox *textBox = new QGroupBox(tr("%1 与 %2 的聊天窗口")
                                       .arg(userName).arg(friendName));
    QVBoxLayout *textLayout = new QVBoxLayout;
    textReceive = new QTextEdit;
    textReceive->setFocusPolicy(Qt::NoFocus);
    textReceive->setReadOnly(true);
    textLayout->addWidget(textReceive);
    textBox->setLayout(textLayout);

    QLabel *msgLabel = new QLabel(tr("消息："));
    messageEdit = new QLineEdit;
    messageEdit->setFocusPolicy(Qt::StrongFocus);
    connect(messageEdit, &QLineEdit::returnPressed, this, &TalkWin::sendButtonClicked);
    msgLabel->setBuddy(messageEdit);
    QHBoxLayout *msgLayout = new QHBoxLayout;
    sendButton = new QPushButton(tr("发送"));
    sendButton->setFocusPolicy(Qt::NoFocus);
    msgLayout->addWidget(msgLabel);
    msgLayout->addWidget(messageEdit);
    msgLayout->addWidget(sendButton);

    connect(sendButton, &QPushButton::clicked, this, &TalkWin::sendButtonClicked);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addWidget(textBox);
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
