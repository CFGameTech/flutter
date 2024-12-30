var cfgCallJsBacks={};
var CFGameRTC = window.webkit.messageHandlers;
var CFGameOpenApi = window.webkit.messageHandlers;
var CFGameLife = window.webkit.messageHandlers;

var cf_game={
    GameRTC:{
            onCFGamePushSelfRTC: function (push, callback) {
                console.log("game push self rtc()");
                var invokeId = getInvokeId();
                cfgCallJsBacks[invokeId] = callback;
                var message = {
                    invokeId:invokeId,
                    data:{
                        push:push
                    }
                };
                CFGameRTC.onCFGamePushSelfRTC.postMessage(message);
            },
            onCFGamePullOtherRTC: function (uid, pull, callback) {
                console.log("game pull other rtc()");
                var invokeId = getInvokeId();
                cfgCallJsBacks[invokeId] = callback;
                var message = {
                    invokeId:invokeId,
                    data:{
                        uid:uid,
                        pull:pull
                    }
                };
                CFGameRTC.onCFGamePullOtherRTC.postMessage(message);
            }
    },
    OpenApi:{
        getBaseInfo: function (callback) {
                    console.log("getBaseInfo()");
                    console.log(window.webkit.messageHandlers);

                    var invokeId = getInvokeId();
                    cfgCallJsBacks[invokeId] = callback;
                    CFGameOpenApi.getBaseInfo.postMessage(invokeId);
        },
        
        getWindowSafeArea: function (callback) {
                       console.log("getWindowSafeArea()");
                       var invokeId = getInvokeId();
                       cfgCallJsBacks[invokeId] = callback;
                       CFGameOpenApi.getWindowSafeArea.postMessage(invokeId);
        },
            
        openChargePage: function () {
            var invokeId = getInvokeId();
            console.log("openChargePage()");
            CFGameOpenApi.openChargePage.postMessage(invokeId);
        },

        closeGamePage: function () {
            var invokeId = getInvokeId();
            console.log("closeGamePage()");
            CFGameOpenApi.closeGamePage.postMessage(invokeId);
        }

    },
    GameLife:{
        getGameloadProgress: function (progress){
            console.log("getGameloadProgress()");
            CFGameOpenApi.getGameloadProgress.postMessage(progress);
        },
        gameLoadFail() {
            console.log("gameLoadFail()");
            CFGameLife.gameLoadFail();
        },
        preJoinGame(uid, seat, callback) {
            console.log("preJoinGame()");
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            var message = {
                invokeId:invokeId,
                data:{
                    uid:uid,
                    seat:seat
                }
            };
            CFGameLife.preJoinGame.postMessage(message);
        },
        joinGame(uid) {
            console.log("joinGame()");
            CFGameLife.joinGame.postMessage(uid);
        },
        gamePrepare(uid) {
            console.log("gamePrepare()");
            CFGameLife.gamePrepare.postMessage(uid);
        },
        cancelPrepare(uid) {
            console.log("cancelPrepare()");
            CFGameLife.cancelPrepare.postMessage(uid);
        },
        gameTerminated(uid) {
            console.log("gameTerminated()");
            CFGameLife.gameTerminated.postMessage(uid);
        },
        gameOver(uid) {
            console.log("gameOver()");
            CFGameLife.gameOver.postMessage(uid);
        },
        gameStart(){
            console.log("gameStart()");
            CFGameLife.gameStart();
        },
        playerRemoveWithUid(uid){
            console.log("playerRemoveWithUid()");
            CFGameLife.playerRemoveWithUid.postMessage(uid);
        },
        gameBackgroundMusicSet(mode){
            console.log("gameBackgroundMusicSet()");
            CFGameLife.gameBackgroundMusicSet.postMessage(mode);
        },
        gameSoundSet(mode){
            console.log("gameSoundSet()");
            CFGameLife.gameSoundSet.postMessage(mode);
        },
        qiutGame(){
            console.log("qiutGame()");
            CFGameLife.qiutGame();
        },
        gameLoadOfflineProps() {
                console.log("gameLoadOfflineProps()");
                CFGameLife.gameLoadOfflineProps();
        },
        
        
    }
};

function getInvokeId(){
    var byteArray = new Uint32Array(1);
    window.crypto.getRandomValues(byteArray);
    return byteArray[0].toString();
}

function callCFJs(invokeId, data) {
    var callback = cfgCallJsBacks[invokeId];
    if(callback == undefined){
        console.log("callback is null !");
    } else {
        callback(JSON.stringify(data));
        delete (cfgCallJsBacks[invokeId]);
    }
}

window.CFGame=cf_game;
