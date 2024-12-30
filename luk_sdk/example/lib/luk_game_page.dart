import 'dart:math';

import 'package:luk_sdk/luk_sdk.dart';
import 'package:flutter/material.dart';

class LukGamePage extends StatefulWidget {
  final int gameId;
  final String gameName;
  final String gameUrl;
  final String roomid;
  final String language;
  final String c_id;
  final String u_id;
  final String token;
  final bool isOwner;

  const LukGamePage(
      {super.key,
        required this.gameId,
        required this.gameName,
        required this.gameUrl,
        required this.roomid,
        required this.language,
        required this.c_id,
        required this.u_id,
        required this.token,
        required this.isOwner}
);

  @override
  State<LukGamePage> createState() {
    return _LukGamePageState();
  }
}

class _LukGamePageState extends State<LukGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )),
          LukGameView(
            key: ValueKey(widget.gameId),
            url: widget.gameUrl,
            gid: widget.gameId.toString(),
            rid: widget.roomid,
            isRoomOwner: widget.isOwner,
            //是否可以打开游戏
            language: widget.language,
            //游戏语言
            width: MediaQuery.of(context).size.width.toInt(),
            height: MediaQuery.of(context).size.height.toInt(),
            cid: widget.c_id,
            uid: widget.u_id,
            token: widget.token,
            padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 32,
                16,
                MediaQuery.of(context).padding.bottom + 16),
            //游戏安全区
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
        ],
      ),
    );
  }
}