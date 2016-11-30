var pillars;
var maxDiscs;
var component;

function initTheDisc(n) {
    maxDiscs = cover.row - 3;
    pillars = new Array()
    var i;
    for(i = 0; i < cover.column; i++)
        pillars[i] = new Array();
    for(i = maxDiscs-n+1; i <= maxDiscs; i++){
        createNewDisc(0, i);
    }
    /*
    for(i = maxDiscs-n+1; i <= maxDiscs; i++){
        createNewDisc(1, i);
    }
    for(i = maxDiscs-n+1; i <= maxDiscs; i++){
        createNewDisc(2, i);
    }
    */
}

function createNewDisc(pillar, disc){
    if(component == null)
        component = Qt.createComponent("Disc.qml");
    if(component.status == Component.Ready){
        var dynamicObject = component.createObject(cover);
        if (dynamicObject === null) {
            console.log("error creating disc");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.dist = disc;
        dynamicObject.x = pillar * cover.rectWidth;
        dynamicObject.y = (cover.row - pillars[pillar].length - 1) * cover.rectHeight;
        dynamicObject.width = cover.rectWidth;
        dynamicObject.height = cover.rectHeight;
        pillars[pillar].push(dynamicObject);
    }
    else {
        console.log("error loading disc component");
        console.log(component.errorString());
        return false;
    }
    return true;
}

var isUp = true;
var tmpDisc;

function pickTheDisc(column){
    tmpDisc = pillars[column].pop();
    tmpDisc.y = 0;
}

function dropTheDisc(column){
    var len = pillars[column].length;
    if(len === 0){
        tmpDisc.x = column * cover.rectWidth;
        tmpDisc.y = (cover.row - 1) * cover.rectHeight;
        pillars[column].push(tmpDisc);
        return true;
    }
    var topDisc = pillars[column][len-1];
    if(tmpDisc.dist < topDisc.dist){
        return false;
    }
    tmpDisc.x = topDisc.x;
    tmpDisc.y = topDisc.y - cover.rectHeight;
    pillars[column].push(tmpDisc);
    return true;
}

function handleClicked(xPos, yPos){
    var column = Math.floor(xPos / cover.rectWidth);
    var row = Math.floor(yPos / cover.rectHeight);
    if(column < 0 || column >= cover.column || row < 0 || row >= cover.row)
        return;
    if(isUp == true){
        if(pillars[column].length > 0){
            pickTheDisc(column);
            isUp = false;
        }
    }
    else{
        if(dropTheDisc(column) === true)
            isUp = true;
    }
}
