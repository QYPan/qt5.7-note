
/*
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "clientsocket.h"
#include "clientmap.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<ClientSocket>("ClientSocket", 1, 0, "ClientSocket");
    qmlRegisterType<ClientMap>("ClientMap", 1, 0, "ClientMap");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
*/

#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml>
#include "clientsocket.h"
#include "clientmap.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<ClientSocket>("ClientSocket", 1, 0, "ClientSocket");
    qmlRegisterType<ClientMap>("ClientMap", 1, 0, "ClientMap");

    QQuickView viewer;
    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    //viewer.rootContext()->setContextProperty("socket", new ClientSocket);
    viewer.setSource(QUrl("qrc:///main.qml"));
    viewer.show();

    return app.exec();
}


