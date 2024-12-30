import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'luk_sdk_platform_interface.dart';
import 'luk_user.dart';
import 'luk_sdk_response.dart';

/// An implementation of [LukSdkPlatform] that uses method channels.
class MethodChannelLukSdk extends LukSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('luk_sdk');

  String uId = '';
  String uCode = '';

  final LukUserProvider _lukUserProvider = LukUserProvider();

  MethodChannelLukSdk(){
    methodChannel.setMethodCallHandler(_methodHandler);
  }

  final StreamController<LukSDKResponse> _responseEventHandler = StreamController.broadcast();

  @override
  Stream<LukSDKResponse> get responseEventHandler =>
      _responseEventHandler.stream;


  Future _methodHandler(MethodCall methodCall){
    if(methodCall.method == "onLoginFailRes"){
      debugPrint("on Login Fail");
      if(methodCall.arguments) {
        Map data = methodCall.arguments;
        debugPrint("Login fail: ${data["msg"]}");
      }
      final response = LukSDKResponse.create(
        methodCall.method,
        methodCall.arguments,
      );

      _responseEventHandler.add(response);
    }else if (methodCall.method == "onLoginSuccessRes"){
      debugPrint(methodCall.arguments);
    }else if(methodCall.method == "onRefrshToken"){
      debugPrint("on RefrshToken");
      final response = LukSDKResponse.create(
        methodCall.method,
        methodCall.arguments,
      );

      _responseEventHandler.add(response);

    }else if(methodCall.method == 'onGetGameFail'){
      debugPrint(methodCall.arguments);
      debugPrint('onGetGameFail');
      final response = LukSDKResponse.create(
        methodCall.method,
        methodCall.arguments,
      );
      _responseEventHandler.add(response);
    }else if(methodCall.method == 'onGetGameList'){
      debugPrint('onGetGameSuccess');
      final response = LukSDKResponse.create(
        methodCall.method,
        methodCall.arguments,
      );
      _responseEventHandler.add(response);

    }
    return Future.value();
  }

  _printLog(Map data){
    debugPrint("LUKLog: ${data["msg"]}");
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }


  Future<void> setupSDK(String appId, String language, bool isProduct) async {
    Map<String, dynamic> param = Map<String, dynamic>();
    param["appId"] = appId;
    param["language"] = language;
    param["isProduct"] = isProduct;

    _lukUserProvider.setSDKData(appId, language, isProduct);

    return await methodChannel.invokeMethod("setupSDK",param);
  }

  Future<void>  setUserInfo(String userId, String userCode) async{
    Map<String, dynamic> param = Map<String, dynamic>();
    param["userId"] = userId;
    param["userCode"] = userCode;
    uId = userId;
    uCode = userCode;

    return await methodChannel.invokeMethod("setUserInfo",param);
  }

  Future<void> getGameList() async{
    return await methodChannel.invokeMethod("getGameList");
  }

  Future<void> releaseSDK() async{
    return await methodChannel.invokeMethod("releaseSDK");
  }



}
