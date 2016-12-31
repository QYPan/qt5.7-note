
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "qmlinterface.h"
#include "clientmap.h"
#include "computergo.h"
#include "myeventfilter.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<QmlInterface>("QmlInterface", 1, 0, "QmlInterface");
    qmlRegisterType<ClientMap>("ClientMap", 1, 0, "ClientMap");

    QQmlApplicationEngine engine;
    MyEventFilter *backKeyFilter = new MyEventFilter;
    engine.rootContext()->setContextProperty("qmlInterface", new QmlInterface);
    engine.rootContext()->setContextProperty("computer", new ComputerGo);
    engine.rootContext()->setContextProperty("backKeyFilter", backKeyFilter);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject *root = NULL;
    QList<QObject *> rootObjects = engine.rootObjects();
    int count = rootObjects.size();
    for(int i = 0; i < count; i++){
        qDebug() << rootObjects.at(i)->objectName();
        if(rootObjects.at(i)->objectName() == "rootObject"){
            root = rootObjects.at(i);
            break;
        }
    }
    backKeyFilter->setRoot(root);
    backKeyFilter->installRootEventFilter();

    return app.exec();
}


/*
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml>
#include "clientsocket.h"
#include "clientmap.h"
#include "computergo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<ClientSocket>("ClientSocket", 1, 0, "ClientSocket");
    qmlRegisterType<ClientMap>("ClientMap", 1, 0, "ClientMap");

    QQuickView viewer;
    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.rootContext()->setContextProperty("socket", new ClientSocket);
    viewer.rootContext()->setContextProperty("computer", new ComputerGo);
    viewer.setSource(QUrl("qrc:///main.qml"));

    QQuickItem *root = NULL;
    root = viewer.rootObject();
    qDebug() << "root name: " << root->isVisible();

    viewer.show();

    return app.exec();
}

*/
