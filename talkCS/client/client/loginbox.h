#ifndef LOGINBOX_H
#define LOGINBOX_H

#include <QWidget>
#include <QString>
#include <QAbstractSocket>
#include "frmmain.h"

class QLineEdit;
class QSpinBox;
class QPushButton;
class QTcpSocket;

class LoginBox : public QWidget{
    Q_OBJECT
public:
    LoginBox(QWidget *parent = 0);
private slots:
    void connectButtonClicked();
    void readData();
    void readError(QAbstractSocket::SocketError);
private:
    QTcpSocket *clientSocket;
    QLineEdit *nameEdit;
    QLineEdit *ipEdit;
    QSpinBox *portBox;
    QPushButton *connectButton;
    FrmMain *fm;
    QString userName;
    void init();
    void sendLoginMessage();
    void getFriendsList();
    void addFriendToList(const QString &data);
};

#endif // LOGINBOX_H
