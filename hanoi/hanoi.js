var pillars = null;
var maxDiscs;
var component;
var currentCount;
var buffer;
var currentColumn = 0;
var currentStep = 0;
var isUp = true;
var tmpDisc = null;

function solve(n, a, b, c){
    if(n == 1){
        buffer.push(a);
        buffer.push(c);
        return;
    }
    solve(n-1, a, c, b);
    buffer.push(a);
    buffer.push(c);
    solve(n-1, b, a, c);
}

function initDiscsPos(n, flag){
    maxDiscs = touchArea.rectRow - 3;
    if(n > maxDiscs) n = maxDiscs;
    currentCount = n;
    clearAllDiscs();
    pillars = new Array(touchArea.rectColumn)
    currentColumn = 0;
    currentStep = 0;
    isUp = true;
    tmpDisc = null;
    var i;
    for(i = 0; i < touchArea.rectColumn; i++)
        pillars[i] = new Array;
    for(i = maxDiscs-n+1; i <= maxDiscs; i++){
        createNewDisc(0, i, flag);
    }
    if(flag){
        buffer = null;
        buffer = new Array;
        currentStep = 0;
        solve(n, 0, 1, 2);
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

function createNewDisc(pillar, disc, flag){
    if(component == null)
        component = Qt.createComponent("Disc.qml");
    if(component.status == Component.Ready){
        var dynamicObject = component.createObject(touchArea);
        if (dynamicObject === null) {
            console.log("error creating disc");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.dist = disc;
        dynamicObject.mult = (touchArea.rectWidth - 30) / 20 - 3;
        var newX;
        var newY;
        //dynamicObject.x = pillar * touchArea.rectWidth;
        //dynamicObject.y = (touchArea.rectRow - pillars[pillar].length - 1) * touchArea.rectHeight;
        newX = pillar * touchArea.rectWidth;
        newY = (touchArea.rectRow - pillars[pillar].length - 1) * touchArea.rectHeight;
        dynamicObject.width = touchArea.rectWidth;
        dynamicObject.height = touchArea.rectHeight;
        dynamicObject.initDiscs(newX, newY);
        if(flag){ //
            dynamicObject.vDisc.connect(touchHandle);
            dynamicObject.hvDisc.connect(touchHandle);
            if(disc == maxDiscs) dynamicObject.initDiscsDone.connect(touchHandle);
        }else{
            if(disc == maxDiscs)
                dynamicObject.hvDisc.connect(openMsgDialog);
        }
        pillars[pillar].push(dynamicObject);
    }
    else {
        console.log("error loading disc component");
        console.log(component.errorString());
        return false;
    }
    return true;
}


function touchHandle(){
    if(currentStep < buffer.length){
        var x = buffer[currentStep] * touchArea.rectWidth + 10;
        var y = 10;
        handleClicked(x, y);
        currentStep += 1;
    }
    else{ // 已经完成所有移动
        clearAllDiscs();
        screen.visible = false;
        beginButton.visible = true;
    }
}

function openMsgDialog(){
    if(pillars[2].length == currentCount){
        msgDialog.visible = true;
        touchArea.enabled = false;
    }
}


function pickTheDisc(column){
    if(pillars != null){
        tmpDisc = pillars[column].pop();
        currentColumn = column;
        tmpDisc.moveDiscV(0);
    }
}

function clearAllDiscs(){
    if(pillars != null){
        var i, j;
        for(i = 0; i < pillars.length; i++)
            for(j = 0; j < pillars[i].length; j++)
                pillars[i][j].destroy();
        pillars = null;
        if(tmpDisc != undefined){
            tmpDisc.destroy();
            tmpDisc = null;
        }
    }
}

function dropTheDisc(column){
    if(pillars != null){
        var len = pillars[column].length;
        var newX, newY
        if(len == 0){
            newX = column * touchArea.rectWidth;
            newY = (touchArea.rectRow - 1) * touchArea.rectHeight;
        }
        else{
            var topDisc = pillars[column][len-1];
            if(tmpDisc.dist < topDisc.dist){
                return false;
            }
            newX = topDisc.x;
            newY = topDisc.y - touchArea.rectHeight;
        }
        if(column == currentColumn)
            tmpDisc.moveDiscV(newY);
        else
            tmpDisc.moveDiscHV(newX, newY);
        pillars[column].push(tmpDisc);
        return true;
    }
}

function handleClicked(xPos, yPos){
    var column = Math.floor(xPos / touchArea.rectWidth);
    var row = Math.floor(yPos / touchArea.rectHeight);
    if(column < 0 || column >= touchArea.rectColumn || row < 0 || row >= touchArea.rectRow)
        return;
    if(tmpDisc != null && (tmpDisc.movingV || tmpDisc.movingHV))
        return;
    if(isUp == true){
        if(pillars[column].length > 0){
            pickTheDisc(column);
            isUp = false;
        }
    }
    else{
        if(dropTheDisc(column) == true){
            if(pillars[2].length == currentCount){
                //msgDialog.visible = true;
            }
            isUp = true;
        }
    }
}
