#include "loginbox.h"
#include "myhelper.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    MyHelper::setUTF8Code();
    LoginBox lb;
    lb.show();

    return app.exec();
}
