#include "calculatethread.h"

CalculateThread::CalculateThread(QObject *parent)
    : QThread(parent)
    , quit(false)
    , m_type(0)
    , oppRow(0)
    , oppColumn(0)
{
    memset(vis, -1, sizeof(vis));
}

CalculateThread::~CalculateThread(){
    quitThread();
}

void CalculateThread::clearChess(){
    memset(vis, -1, sizeof(vis));
}

void CalculateThread::initFirst(int row, int column, int type){
    vis[row][column] = type;
}

void CalculateThread::requestChessPos(int row, int column, int type){
    QMutexLocker locker(&mutex);
    oppRow = row;
    oppColumn = column;
    m_type = type;
    vis[row][column] = m_type ^ 1;
    if(!isRunning()){
        start();
    }else{
        cond.wakeOne();
    }
}

void CalculateThread::quitThread(){
    if(!quit){
        mutex.lock();
        quit = true;
        cond.wakeOne();
        mutex.unlock();
        clearChess(); // 退出线程前清空棋盘
        wait();
    }
}

void CalculateThread::run(){
    while(!quit){
        int newRow = 0, newColumn = 0;
        int count = 0;
        double t = 0.0, p = 0.0;
        computerGo(vis, m_type, newColumn, newRow, count, t, p);
        mutex.lock();
        vis[newRow][newColumn] = m_type;
        emit sendAnswer(newRow, newColumn);
        cond.wait(&mutex);
        mutex.unlock();
    }
}

