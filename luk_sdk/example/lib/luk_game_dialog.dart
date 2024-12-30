import 'dart:ffi';

import 'package:luk_sdk/luk_sdk.dart';
import 'package:flutter/material.dart';

class LukGameDialog{
  static void showGameDialog(BuildContext context,
      {required int gameId,
        required String gameName,
        required String gameUrl,
        required String roomid,
        required String language,
        required String c_id,
        required String u_id,
        required String token,
        required bool isOwner
      }) {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.2),
                ),
                Expanded(
                  child: LukGameView(
                    
                    key: ValueKey(gameId),
                    url: gameUrl,
                    gid: gameId.toString(),
                    rid: roomid,
                    //这里填写业务方的房间ID
                    isRoomOwner: isOwner,
                    //是否可以打开游戏
                    language: language,
                    //游戏语言
                    width: MediaQuery.of(context).size.width.toInt(),
                    height: (MediaQuery.of(context).size.height * 0.8).toInt(),
                    cid: c_id,
                    //Luk SDK的appId
                    uid: u_id,
                    //业务用户Uid
                    token: token,
                    //业务token,
                    padding: EdgeInsets.zero,
                    preJoinGame: (int uid, int seat) async {
                      //TODO 加入前回调
                      return true;
                    },
                    openChargePage: () async {
                      //TODO 跳转 到充值页面
                    },
                    closeGamePage: () async {
                      print("退出 ");
                      Navigator.of(context).pop();
                    },

                  ),
                ),
              ],
            ),
          );
        });
  }
}