/****************************************************************************
** Meta object code from reading C++ file 'frmmain.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../server/frmmain.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'frmmain.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_FrmMain_t {
    QByteArrayData data[6];
    char stringdata0[65];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FrmMain_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FrmMain_t qt_meta_stringdata_FrmMain = {
    {
QT_MOC_LITERAL(0, 0, 7), // "FrmMain"
QT_MOC_LITERAL(1, 8, 13), // "clientConnect"
QT_MOC_LITERAL(2, 22, 0), // ""
QT_MOC_LITERAL(3, 23, 4), // "name"
QT_MOC_LITERAL(4, 28, 16), // "clientDisConnect"
QT_MOC_LITERAL(5, 45, 19) // "listenButtonClicked"

    },
    "FrmMain\0clientConnect\0\0name\0"
    "clientDisConnect\0listenButtonClicked"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FrmMain[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    1,   29,    2, 0x08 /* Private */,
       4,    1,   32,    2, 0x08 /* Private */,
       5,    0,   35,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void,

       0        // eod
};

void FrmMain::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        FrmMain *_t = static_cast<FrmMain *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->clientConnect((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->clientDisConnect((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 2: _t->listenButtonClicked(); break;
        default: ;
        }
    }
}

const QMetaObject FrmMain::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_FrmMain.data,
      qt_meta_data_FrmMain,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *FrmMain::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FrmMain::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_FrmMain.stringdata0))
        return static_cast<void*>(const_cast< FrmMain*>(this));
    return QWidget::qt_metacast(_clname);
}

int FrmMain::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
