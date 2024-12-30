import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LukGameView extends StatefulWidget {
  final String url; //游戏链接
  final String cid; //渠道id
  final String gid; //游戏id
  final String uid; //用户id
  final String rid; //房间id
  final String token; //用户token
  final String language; //游戏语言
  final bool isRoomOwner; //是否为房主
  final int width;  //游戏页宽
  final int height; //游戏页高
  final EdgeInsets padding; //游戏页的安全区距离

  final Future<void> Function()? gameLoadFail; //游戏加载失败回调
  final Future<bool> Function(int uid, int seat)? preJoinGame;  //游戏准备回调
  final Future<void> Function(int uid)? joinGame;
  final Future<void> Function(int uid)? gamePrepare; //玩家准备回调
  final Future<void> Function(int uid)? cancelPrepare; //玩家取消准备回调
  final Future<void> Function(int uid)? gameTerminated; //强制结束游戏回调
  final Future<void> Function(int uid)? gameOver; //结束对局回调

  final Future<void> Function()? openChargePage; //打开充值页面回调
  final Future<void> Function()? closeGamePage; //关闭游戏页面回调

  const LukGameView({
    super.key,
    required this.url,
    required this.cid,
    required this.gid,
    required this.uid,
    required this.rid,
    required this.token,
    required this.language,
    required this.isRoomOwner,
    required this.width,
    required this.height,
    required this.padding,
    this.gameLoadFail,
    this.preJoinGame,
    this.joinGame,
    this.gamePrepare,
    this.cancelPrepare,
    this.gameTerminated,
    this.gameOver,
    this.openChargePage,
    this.closeGamePage,
}); 
  
  
  @override
  State<LukGameView> createState() => _LukGameViewState();
}

class _LukGameViewState extends State<LukGameView> {
  final WebViewController _controller = WebViewController();

  @override
  void initState(){
    super.initState();
    _initController();
  }
  
  void _initController() async {
    final jsFile = await rootBundle.loadString('packages/luk_sdk/assets/luk_game_channel.js');

    _controller
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('CFGameLifeCaller', onMessageReceived: (msg){
        final param = jsonDecode(msg.message);
        if(param['func'] == 'gameLoadFail') {
          widget.gameLoadFail?.call();
        }else if (param['func'] == 'joinGame') {
          final userId = param['userId'];
          widget.joinGame?.call(int.parse(userId));
        } else if (param['func'] == 'gamePrepare') {
          final userId = param['userId'];
          widget.gamePrepare?.call(int.parse(userId));
        } else if (param['func'] == 'cancelPrepare') {
          final userId = param['userId'];
          widget.cancelPrepare?.call(int.parse(userId));
        } else if (param['func'] == 'gameTerminated') {
          final userId = param['userId'];
          widget.gameTerminated?.call(int.parse(userId));
        } else if (param['func'] == 'gameOver') {
          final userId = param['userId'];
          widget.gameOver?.call(int.parse(userId));
        } else if (param['func'] == 'preJoinGame') {
          final invokeId = param['invokeId'];
          final userId = widget.uid;
          final seat = param['seat'];
          if (widget.preJoinGame != null) {
            widget.preJoinGame!(int.parse(userId), seat).then((value) {
              final js = '''
                cfgCallJsBacks['$invokeId'](JSON.stringify({
                  code: ${value ? 0 : -1},
                  msg: ${value ? '"success"' : '"fail"'},
                  result: {
                    is_ready: ${value ? 'true' : 'false'}
                   }
                }));
              ''';
              _controller.runJavaScript(js);
            });
          } else {
            final js = '''
                cfgCallJsBacks['$invokeId'](JSON.stringify({
                  code: 0,
                  msg: 'success',
                  result: {
                    is_ready: true
                  }
                }));
              ''';

            _controller.runJavaScript(js);
          }
        }
      })
      ..addJavaScriptChannel('CFGameOpenApiCaller', onMessageReceived: (msg){
        final param = jsonDecode(msg.message);
        if (param['func'] == 'getBaseInfo') {
          final invokeId = param['invokeId'];
          double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
          final js = '''
            cfgCallJsBacks['$invokeId'](JSON.stringify({
              code: 0,
              msg: 'success',
              result: {
                cid: '${widget.cid}',
                gid: '${widget.gid}',
                uid: '${widget.uid}',
                token: '${widget.token}',
                version: '1.0.0',
                language: '${widget.language}',
                window: '${widget.width * devicePixelRatio}x${widget.height * devicePixelRatio}',
                rid: '${widget.rid}',
                room_owner: ${widget.isRoomOwner ? 'true' : 'false'}
              }
            }));
          ''';
          _controller.runJavaScript(js);
        } else if (param['func'] == 'getWindowSafeArea') {
          final invokeId = param['invokeId'];

          final js = '''
            cfgCallJsBacks['$invokeId'](JSON.stringify({
              code: 0,
              msg: 'success',
              result: {
                top: ${widget.padding.top},
                left: ${widget.padding.left},
                right: ${widget.padding.right},
                bottom: ${widget.padding.bottom},
                scale_min_limit: 0.01
              }
            }));
          ''';
          _controller.runJavaScript(js);
        }else if(param['func'] == 'openChargePage'){
          widget.openChargePage?.call();
        }else if(param['func'] == 'closeGamePage'){
          widget.closeGamePage?.call();
        }
      })
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            _controller.runJavaScript(jsFile);
          },
          onProgress: (int progress){
            LinearProgressIndicator(
              value: progress / 100, // 将进度值转换为0到1之间的数值
            );
          }
        ),
      )

      ..loadRequest(Uri.parse(widget.url));
  }
  


  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}

