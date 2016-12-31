TEMPLATE = app

QT += core qml quick network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
CONFIG += c++11

SOURCES += main.cpp \
    clientmap.cpp \
    calculate.cpp \
    calculatethread.cpp \
    computergo.cpp \
    myeventfilter.cpp \
    datastruct.cpp \
    clientsocket.cpp \
    socketthread.cpp \
    qmlinterface.cpp

RESOURCES += resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    clientmap.h \
    calculate.h \
    calculatethread.h \
    computergo.h \
    myeventfilter.h \
    clientsocket.h \
    datastruct.h \
    socketthread.h \
    qmlinterface.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
