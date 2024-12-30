
import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../src/luk_sdk_platform_interface.dart';
import 'luk_sdk_response.dart';
import 'cancelable.dart';

class LukSdk {
  Future<String?> getPlatformVersion() {
    return LukSdkPlatform.instance.getPlatformVersion();
  }

  LukSdk(){
    _streamSubscription = LukSdkPlatform.instance.responseEventHandler.listen(
      _responseEventListener,
      onDone: (){
        _streamSubscription?.cancel();
      },
    );
  }

  final _responseListeners = <LukSDKResponseSubscriber>[];
  StreamSubscription? _streamSubscription;

  void _responseEventListener(LukSDKResponse event){
    for (final listener in _responseListeners.toList()){
      debugPrint("event ");
      listener(event);
    }
  }



  //  初始化SDK
  Future<void> setupSDK(String appId, String language, bool isProduct){
    return LukSdkPlatform.instance.setupSDK(appId, language, isProduct);
  }

  /*
   *   void onLoginSuccess;
   *   void onLoginFail(int code, String msg);
   */
  ///
  //  设置用户信息（登录）
  Future<void> setUserInfo(String userId, String userCode){
    return LukSdkPlatform.instance.setUserInfo(userId, userCode);
  }


  //  获取游戏列表
  Future<void>  getGameList(){
    return LukSdkPlatform.instance.getGameList();
  }

  // 释放SDK
  Future<void> releaseSDK(){
    return LukSdkPlatform.instance.releaseSDK();
  }



  LukCancelable addSubscriber(LukSDKResponseSubscriber listener){
    _responseListeners.add(listener);
    return LukCancelableImpl(onCancel: (){
      removeSubscriber(listener);
    });
  }


  void removeSubscriber(LukSDKResponseSubscriber listener){
    _responseListeners.remove(listener);
  }


  void clearSubscribers(){
    _responseListeners.clear();
  }

}
