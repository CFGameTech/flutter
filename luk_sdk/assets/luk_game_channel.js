
var CFGameLife = {
    gameLoadFail: function () {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "gameLoadFail",
        }));
    },

    preJoinGame: function (uid, seat, invokeId) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "preJoinGame",
            invokeId: invokeId,
            userId: uid,
            seat: seat
        }));
    },

    joinGame: function (uid) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "joinGame",
            userId: uid
        }));
    },

    gamePrepare: function (uid) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "gamePrepare",
            userId: uid
        }));
    },

    cancelPrepare: function (uid) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "cancelPrepare",
            userId: uid
        }));
    },

    gameTerminated: function (uid) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "gameTerminated",
            userId: uid
        }));
    },

    gameOver: function (uid) {
        CFGameLifeCaller.postMessage(JSON.stringify({
            func: "gameOver",
            userId: uid
        }));
    }
};

var CFGameOpenApi = {
    getBaseInfo: function (invokeId) {
        CFGameOpenApiCaller.postMessage(JSON.stringify({
            func: "getBaseInfo",
            invokeId: invokeId
        }));
    },

    getWindowSafeArea: function (invokeId) {
        CFGameOpenApiCaller.postMessage(JSON.stringify({
            func: "getWindowSafeArea",
            invokeId: invokeId
        }));
    },

    openChargePage: function () {
        CFGameOpenApiCaller.postMessage(JSON.stringify({
            func: "openChargePage"
        }));
    },

    closeGamePage: function () {
        CFGameOpenApiCaller.postMessage(JSON.stringify({
            func: "closeGamePage"
        }));
    }
};


var cfgCallJsBacks = {};

var cf_game = {
    OpenApi: {
        getBaseInfo: function (callback) {
            console.log("getBaseInfo()");
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            CFGameOpenApi.getBaseInfo(invokeId);
        },

        getWindowSafeArea: function (callback) {
            console.log("getWindowSafeArea()");
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            CFGameOpenApi.getWindowSafeArea(invokeId);
        },

        openChargePage: function () {
            console.log("openChargePage()");
            CFGameOpenApi.openChargePage();
        },

        closeGamePage: function () {
            console.log("closeGamePage()");
            CFGameOpenApi.closeGamePage();
        }
    },
    GameLife: {
        gameLoadFail() {
            console.log("gameLoadFail()");
            CFGameLife.gameLoadFail();
        },
        preJoinGame(uid, seat, callback) {
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            console.log("call preJoinGame()", invokeId, uid, seat, callback);
            CFGameLife.preJoinGame(uid, seat, invokeId);
        },
        joinGame(uid) {
            console.log("joinGame()");
            CFGameLife.joinGame(uid);
        },
        gamePrepare(uid) {
            console.log("gamePrepare()");
            CFGameLife.gamePrepare(uid);
        },
        cancelPrepare(uid) {
            console.log("cancelPrepare()");
            CFGameLife.cancelPrepare(uid);
        },
        gameTerminated(uid) {
            console.log("gameTerminated()");
            CFGameLife.gameTerminated(uid);
        },
        gameOver(uid) {
            console.log("gameOver()");
            CFGameLife.gameOver(uid);
        }
    },
    GameRTC: {
        onCFGamePushSelfRTC: function (push, callback) {
            console.log("gameLoadSuccess()");
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            //                            CFGameRTC.onCFGamePushSelfRTC(push);
        },
        onCFGamePullOtherRTC: function (uid, pull, callback) {
            console.log("gameLoadFail()");
            var invokeId = getInvokeId();
            cfgCallJsBacks[invokeId] = callback;
            //                            CFGameRTC.onCFGamePullOtherRTC(uid, pull);
        }
    }
};

function getInvokeId() {
    return Date.now().toString();
}

function callCFJs(invokeId, data) {
    var callback = cfgCallJsBacks[invokeId];
    if (callback == undefined) {
        console.log("callback is null !");
    } else {
        console.log("recv callback data", data);
        callback(data);
        delete (cfgCallJsBacks[invokeId]);
    }
}

window.CFGame = cf_game;