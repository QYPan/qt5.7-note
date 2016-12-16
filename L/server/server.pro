QT += gui \
      network \
      testlib
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11
QMAKE_CXXFLAGS += -std=c++0x

TARGET = server
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    singletcpserver.cpp \
    clientlistwin.cpp \
    clientsocket.cpp \
    datastruct.cpp

HEADERS += \
    singletcpserver.h \
    clientlistwin.h \
    clientsocket.h \
    datastruct.h
