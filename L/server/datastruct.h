#ifndef DATASTRUCT_H
#define DATASTRUCT_H

#include <QString>

class ClientSocket;

enum MessageType {LOGIN, ADD_ONE, ADD_ALL, TRANSPOND
                  , ADD_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED
                  , OFFLINE, TRANSPOND_SUCCESSED};

struct DataStruct
{
    DataStruct()
        : message("")
        , name("")
        , ip("")
    {}
    QString message;
    QString name;
    QString ip;
    int port;
    MessageType mark;
    ClientSocket *socket;
};

#endif // CLIENTTHREAD_H
