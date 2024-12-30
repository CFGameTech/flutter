import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'luk_sdk_response.dart';
import 'luk_sdk_method_channel.dart';

abstract class LukSdkPlatform extends PlatformInterface {
  /// Constructs a LukSdkPlatform.
  LukSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static LukSdkPlatform _instance = MethodChannelLukSdk();

  /// The default instance of [LukSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelLukSdk].
  static LukSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LukSdkPlatform] when
  /// they register themselves.
  static set instance(LukSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<LukSDKResponse> get responseEventHandler{
    throw UnimplementedError('responseEventHandler() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///
  //  初始化SDK
  Future<void> setupSDK(String appId, String language, bool isProduct){
    throw UnimplementedError('setupSDK() has not been implemented.');
  }

  ///
  //  设置用户信息（登录）
  Future<void> setUserInfo(String userId, String userCode){
    throw UnimplementedError('setUserInfo() has not been implemented.');
  }

  //
  Future<void> getGameList(){
    throw UnimplementedError('getGameList() has not been implemented.');
  }

  //
  Future<void> releaseSDK(){
    throw UnimplementedError('releaseSDK() has not been implemented.');
  }



}
