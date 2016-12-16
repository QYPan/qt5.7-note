#include <QApplication>
#include "clientlistwin.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    ClientListWin win;
    win.show();
    return app.exec();
}
