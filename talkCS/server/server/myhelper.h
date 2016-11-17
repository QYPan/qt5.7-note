#ifndef MYHELPER_H
#define MYHELPER_H

#include <QTextCodec>
#include <QWidget>

class MyHelper : public QObject{
public:
    static void setUTF8Code(){
        QTextCodec *codec = QTextCodec::codecForName("UTF-8");
        QTextCodec::setCodecForLocale(codec);
        //QTextCodec::setCodecForCStrings(codec);
        //QTextCodec::setCodecForTr(codec);
    }
};

class FormHelper : public QObject{
public:
    //窗体不能改变大小
    static void formNotResize(QWidget *frm)
    {
        frm->setFixedSize(frm->width(), frm->height());
    }

};


#endif // MYHELPER_H
