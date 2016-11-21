#ifndef TALKWIN_H
#define TALKWIN_H

#include <QWidget>
#include <QDialog>
#include <QString>
#include <QByteArray>

class QLineEdit;
class QTextEdit;
class QPushButton;
class QCLoseEvent;

class TalkWin : public QDialog{
    Q_OBJECT
public:
    explicit TalkWin(const QString _user, const QString _friend, QWidget *parent = 0);
    QTextEdit *textReceive;
    void Destroy();
protected:
    void closeEvent(QCloseEvent *event);
signals:
    void sendData(QByteArray data);
    void readyToClose(QString name);
private slots:
    void sendButtonClicked();
private:
    QString userName;
    QString friendName;
    QLineEdit *messageEdit;
    QPushButton *sendButton;
    void init();
};

#endif // TALKWIN_H
