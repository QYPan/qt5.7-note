import QtQuick 2.0

Item {
    id: disc
    property int dist: 1
    property real mult: 1
    property real newX
    property real newY
    property alias movingV: moveV.running
    property alias movingHV: moveHV.running
    property variant colorArray: ["#00bde3", "#67c111",
        "#ea7025", "#aa7954", "#ff7332", "#98ffda", "#334323",
        "#776655", "#ddadfa", "#442346"]
    signal vDisc()
    signal hvDisc()
    signal initDiscsDone()

    function moveDiscV(ty){
        newY = ty;
        moveV.start();
    }
    function moveDiscHV(tx, ty){
        newX = tx;
        newY = ty;
        moveHV.start();
    }
    function initDiscs(tx, ty){
        newX = tx;
        newY = ty;
        initDown.start();
    }
    ParallelAnimation {
        id: initDown
        NumberAnimation{
            target: disc
            property: "x"
            to: newX
            //duration: 100
            easing.type: Easing.OutBounce
        }
        NumberAnimation{
            target: disc
            property: "y"
            to: newY
            //duration: 100
            easing.type: Easing.OutBounce
        }
        onStopped: initDiscsDone();
    }
    NumberAnimation{
        id: moveV
        target: disc
        property: "y"
        to: newY
        duration: 600
        easing.type: Easing.OutBounce
        onStopped: vDisc();
    }
    SequentialAnimation {
        id: moveHV
        NumberAnimation{
            target: disc
            property: "x"
            to: newX
            duration: 600
            easing.type: Easing.OutBounce
        }
        NumberAnimation{
            target: disc
            property: "y"
            to: newY
            duration: 600
            easing.type: Easing.OutBounce
        }
        onStopped: hvDisc();
    }
    Rectangle {
        id: rect
        visible: true
        anchors.fill: parent
        //anchors.margins: 1
        anchors.leftMargin: dist * mult
        anchors.rightMargin: dist * mult
        color: Qt.lighter(disc.colorArray[dist])
        radius: 5
        border.color: "green"
        border.width: 2
    }
}
