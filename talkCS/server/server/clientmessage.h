#ifndef CLIENTMESSAGE_H
#define CLIENTMESSAGE_H

#include <QString>

struct ClientMsg{
    int ID;
    QString IP;
    int Port;
    ClientMsg(int id = 0, QString ip = "", int port = 0)
    : ID(id), IP(ip), Port(port)
    {
    }
};

#endif // CLIENTMESSAGE_H
