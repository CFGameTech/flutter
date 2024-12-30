
import 'package:flutter/material.dart';


class LukUserModel {
  final String uid;
  final String code;
  final String token;

  LukUserModel({
    required this.uid,
    required this.code,
    required this.token
});

  LukUserModel.empty() : uid = '',code = '', token = '';

}

class LukSDKModel{
  /// 渠道id
  final String cid;
  final String language;
  final bool isProduct;

  LukSDKModel({
    required this.cid,
    required this.language,
    required this.isProduct
  });

    LukSDKModel.empty() : cid = '', language = '', isProduct = false;
}

class LukUserProvider with ChangeNotifier {


    LukSDKModel _sdkModel = LukSDKModel.empty();
    LukUserModel _userModel = LukUserModel.empty();

    LukSDKModel get sdkModel => _sdkModel;
    LukUserModel get userModel => _userModel;

    void setLoginData(String uid, String code, String token){
      _userModel = LukUserModel(uid: uid, code: code, token: token);
    }

    LukUserModel getUserModel(){
      return _userModel;
    }

    void setSDKData(String cId, String language, bool isProduct){
      _sdkModel = LukSDKModel(cid: cId, language: language, isProduct: isProduct);
    }

    LukSDKModel getSDKData(){
      return _sdkModel;
    }


}



class LukUser {
  static final LukUser _user = LukUser._instance();

  factory LukUser(){
    return _user;
  }

  LukUser._instance();
}