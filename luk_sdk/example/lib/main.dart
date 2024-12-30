import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:luk_sdk/luk_sdk.dart';

import 'luk_game_dialog.dart';
import 'luk_game_page.dart';


void main(){
  runApp(MaterialApp(
      home: MyApp(),
      title: "My",
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _lukSdkPlugin = LukSdk();
  TextEditingController _appIdTEC = TextEditingController();
  TextEditingController _languageTEC = TextEditingController();
  TextEditingController _isProductTEC = TextEditingController();

  TextEditingController _userIdTEC = TextEditingController();
  TextEditingController _userCodeTEC = TextEditingController();

  TextEditingController _halfGameIdTEC = TextEditingController();
  TextEditingController _fullGameIdTEC = TextEditingController();

  late Function(LukSDKResponse) responseListener;
  String _resultToken = '';
  List<dynamic> _GameListArr = List.empty();

  @override
  void dispose() {
    super.dispose();
    _lukSdkPlugin.removeSubscriber(responseListener);
  }


  @override
  void initState() {
    super.initState();
    initPlatformState();
    responseListener = (response){
      if (response is LukOnRefrshTokenRes){
        setState(() {
          if (response.isSuccessful){
            debugPrint('main page debug ${response.token}');
            _resultToken = response.token as String;
          }else{
            debugPrint('loginFail code: ${response.code} msg: ${response.msg}');
          }

        });

      }else if (response is LukOnGetGameListRes){
        debugPrint('main page debug ${response}');
        setState(() {
          if(response.isSuccessful){
            List<dynamic> gamelist = response.gameList as List;
            _GameListArr = gamelist;
          }else{
            debugPrint('loginFail code: ${response.code} msg: ${response.msg}');
          }
        });
      }


    };
    _lukSdkPlugin.addSubscriber(responseListener);
  }


  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _lukSdkPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    print('platformVersion : $platformVersion');

    _appIdTEC.text = "1002401";
    _languageTEC.text = "zh_CN";
    _isProductTEC.text = 'false';

    _userIdTEC.text = "1233";
    _userCodeTEC.text = "123";

    _halfGameIdTEC.text = "68";
    _fullGameIdTEC.text = "53";

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUK SDK Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LUK SDK Demo'),
            backgroundColor:Colors.lightBlueAccent,
            foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child:TextField(controller: _appIdTEC,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        hintText: '请输入appid',
                        hintStyle: TextStyle(color: Colors.grey)),
                        style: TextStyle(fontSize: 12),
                    )
                  ),
                  Expanded(child:TextField(controller: _languageTEC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        hintText: '请输入language',
                        hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(fontSize: 12),
                  )
                  ),
                  Expanded(child:TextField(controller: _isProductTEC,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        hintText: '请输入isProduct',
                        hintStyle: TextStyle(color: Colors.grey)),
                        style: TextStyle(fontSize: 12),
                  )
                  ),
                ]
              ),
              Center(child:
                    ElevatedButton(onPressed: (){
                      print('init btn click');
                      if(_appIdTEC.text.isNotEmpty && _languageTEC.text.isNotEmpty && _isProductTEC.text.isNotEmpty){

                        var appId = _appIdTEC.text;
                        var language = _languageTEC.text;
                        var isProduct = _isProductTEC.text.toLowerCase() == 'true';

                        print("appid: ${appId}, language: ${language}, isProduct: ${isProduct}");

                        _lukSdkPlugin.setupSDK(appId, language, isProduct);

                      }
                    },
                      child: Text('sdk init',style: TextStyle(fontSize: 18),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
                  )
              ),
              Row(
                  children: <Widget>[
                    Expanded(child:TextField(controller: _userIdTEC,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                          hintText: '请输入userid',
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(fontSize: 12),
                    )
                    ),
                    Expanded(child:TextField(controller: _userCodeTEC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(border: OutlineInputBorder(),
                          hintText: '请输入usercode',
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(fontSize: 12),
                    )
                    ),
                  ]
              ),
              Center(child:
                        ElevatedButton(onPressed: (){
                          print('login btn click');
                          if(_userIdTEC.text.isNotEmpty) {
                            var userId = _userIdTEC.text;
                            var userCode = _userCodeTEC.text;

                            print("userId: ${userId}, userCode: ${userCode}");

                            _lukSdkPlugin.setUserInfo(userId, userCode);
                          }
                          },
                           child: Text('sdk login',style: TextStyle(fontSize: 18),),
                           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
                    )
              ),
              Center(child:
              ElevatedButton(onPressed: (){
                _lukSdkPlugin.getGameList();
                print('btn click');
              },
                child: Text('get game list',style: TextStyle(fontSize: 18),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
              )
              ),
              Row(
                  children: <Widget>[
                    Expanded(child:TextField(controller:_halfGameIdTEC ,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                          hintText: '请输入gid',
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(fontSize: 12),
                    )
                    ),
                    Expanded(child:ElevatedButton(onPressed: (){

                      for (Map gameData in _GameListArr){

                        int g_id = gameData["g_id"];
                        int sel_g_id = int.parse(_halfGameIdTEC.text);
                        if(g_id == sel_g_id){


                          LukGameDialog.showGameDialog(context, gameId: g_id,
                              gameName: gameData["g_name"],
                              gameUrl: gameData["g_url"],
                              roomid: "1001",
                              language: _languageTEC.text,
                              c_id: _appIdTEC.text,
                              u_id: _userIdTEC.text,
                              token: _resultToken,
                              isOwner:true);
                        }
                      }



                    },
                      child: Text('打开半屏游戏',style: TextStyle(fontSize: 18),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
                    )
                    ),
                  ]
              ),
              Row(

                  children: <Widget>[
                    Expanded(child:TextField(controller: _fullGameIdTEC,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(border: OutlineInputBorder(),
                          hintText: '请输入gid',
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(fontSize: 12),
                    )
                    ),
                    Expanded(child:ElevatedButton(onPressed: (){

                      for (Map gameData in _GameListArr){

                        int g_id = gameData["g_id"];
                        int sel_g_id = int.parse(_fullGameIdTEC.text);
                        if(g_id == sel_g_id){

                          var webView = MaterialPageRoute(
                              builder: (context) => LukGamePage(gameId:g_id,
                                  gameName: gameData["g_name"],
                                  gameUrl: gameData["g_url"],
                                  roomid:"1001" ,
                                  language: _languageTEC.text,
                                  c_id: _appIdTEC.text,
                                  u_id: _userIdTEC.text,
                                  token: _resultToken,
                                  isOwner:true)
                          );

                          Future.delayed(Duration(milliseconds: 1000),(){
                            Navigator.of(context).push(webView);
                          });


                        }
                      }



                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => const LukGamePage(gameId: 68, gameName: "Ludo", gameUrl: "https://games.lucky9studio.com/sdk/app_Debug/ludo2/index.html")
                        // ));


                    },
                          child: Text('打开全屏游戏',style: TextStyle(fontSize: 18),),
                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
                            )
                    ),
                  ]
              ),
              Center(child:
                        ElevatedButton(onPressed: (){
                            _lukSdkPlugin.releaseSDK();
                          },
                        child: Text('sdk release',style: TextStyle(fontSize: 18),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white,minimumSize: Size(150, 40,)),
                  )
              ),
            ],
          ),

          //Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

