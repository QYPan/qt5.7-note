#ifndef FRMMAIN_H
#define FRMMAIN_H

#include <QWidget>
#include <QString>
#include <QAbstractSocket>

class QListWidget;
class QTcpSocket;

class FrmMain : public QWidget{
    Q_OBJECT
public:
    explicit FrmMain(QString name, QWidget *parent = 0);
    QListWidget *friendLists;
private slots:
private:
    QString userName;
    void init();
};

#endif // FRMMAIN_H
