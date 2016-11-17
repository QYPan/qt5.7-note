#include "frmmain.h"
#include "myhelper.h"
#include <QTcpSocket>
#include <QListWidget>
#include <QVBoxLayout>
#include <QMessageBox>

FrmMain::FrmMain(QString name, QWidget *parent)
: QWidget(parent), userName(name)
{
    this->init();
}

void FrmMain::init(){
    resize(300, 500);
    FormHelper::formNotResize(this);
    friendLists = new QListWidget;
    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addWidget(friendLists);
    setLayout(mainLayout);
    setWindowTitle(userName);
}
