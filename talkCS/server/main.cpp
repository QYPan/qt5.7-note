#include "frmmain.h"
#include "myhelper.h"
#include <QApplication>

int main(int argc, char *argv[]){
    QApplication app(argc, argv);

    MyHelper::setUTF8Code();
    FrmMain fm;
    fm.show();

    return app.exec();
}
