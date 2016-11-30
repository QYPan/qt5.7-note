import QtQuick 2.0

Item {
    id: disc
    property int dist: 1

    Behavior on x {
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutBounce
        }
    }

    Behavior on y {
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutBounce
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 1
        anchors.leftMargin: dist * 14
        anchors.rightMargin: dist * 14
        color: "green"
        radius: 5
        border.color: "yellow"
        border.width: 3
    }
}
