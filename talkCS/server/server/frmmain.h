#ifndef FRMMAIN_H
#define FRMMAIN_H

#include <QWidget>
#include <QString>
#include "mytcpserver.h"

class QListWidget;
class QPushButton;
class QSpinBox;
class QLineEdit;

class FrmMain : public QWidget{
    Q_OBJECT
public:
    explicit FrmMain(QWidget *parent = 0);
    //~frmMain();
private slots:
    void clientConnect(QString name);
    void clientDisConnect(QString name);
    void listenButtonClicked();
private:
    QListWidget *clientLists; // 客户列表
    QPushButton *listenButton;
    QLineEdit *ipEdit;
    QSpinBox *portNumber;
    MyTcpServer *server;
    void init();
    QString getLocalHostIpAddress();
};

#endif // FRMMAIN_H
