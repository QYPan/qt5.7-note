#ifndef MYHELPER_H
#define MYHELPER_H

#include <QTextCodec>
#include <QWidget>
#include <QPixmap>
#include <QPalette>

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

    // 为窗体添加最小化选项
    static void addMinimizeButtonHint(QWidget *frm){
        frm->setWindowFlags(Qt::WindowMinimizeButtonHint); // 不是所有平台都使用
    }

    // 设置窗口背景图片
    static void setWinBackground(QWidget *frm, QPixmap pixmap){
        frm->setAutoFillBackground(frm);
        QPalette pl = frm->palette();
        pl.setBrush(QPalette::Window, QBrush(pixmap));
        frm->setPalette(pl);
    }
};

#endif // MYHELPER_H
