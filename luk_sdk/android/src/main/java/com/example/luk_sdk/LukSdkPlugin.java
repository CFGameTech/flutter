package com.example.luk_sdk;
//package com.cftech.gamesdk;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


import com.cftech.gamelibrary.CFGameSDK;
import com.cftech.gamelibrary.interfaces.ICFGameListCallback;
import com.cftech.gamelibrary.module.CFGameList;
//import com.cftech.gamelibrary.CFGameSDKInternal;
//import com.cftech.gamelibrary.engine.CFGameService;
//import com.cftech.gamelibrary.event.OpenApiEvent;
//import com.cftech.gamelibrary.interfaces.ICFGameListCallback;
//import com.cftech.gamelibrary.module.CFGameList;
//import com.cftech.gamelibrary.utils.CFDensityUtil;
//import com.cftech.gamelibrary.utils.CFFP;
//import com.cftech.gamelibrary.view.dialog.CFGameListDialog;
//import com.cftech.gamelibrary.view.webview.CFGWebView;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.content.Context;


/** LukSdkPlugin */
public class LukSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;
  private String TAG = "LukSdkPlugin";

  private String errMsg = "msg";
  private String errCode = "code";
  private String mtoken = "token";
  private String mgameList = "gameList";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "luk_sdk");
    channel.setMethodCallHandler(this);

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("setupSDK")) {
        setupSDK(call,result);
    } else if(call.method.equals("setUserInfo")){
        setUserInfo(call,result);
    } else if(call.method.equals("getGameList")){
        getGameList(call,result);
    } else if(call.method.equals("releaseSDK")){
        releaseSDK(call,result);
    } else result.notImplemented();
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public void setupSDK(MethodCall call, Result result){
        int appid = Integer.parseInt(call.argument("appId"));
        String language =  call.argument("language");
        boolean isProduct = call.argument("isProduct");

    CFGameSDK.initSDK(this.activity.getApplication(),appid,  language, isProduct);

  }

  public void setUserInfo(MethodCall call, Result result){

    String userId = call.argument("userId");
    String userCode =  call.argument("userCode");

    CFGameSDK.setUserInfo(userId,userCode, new CFGameSDK.ICFLoginCallback() {

      @Override
      public void onLoginSuccess() {
        Log.i(TAG, "on Login Success.");
        Map result = new HashMap<>();
        result.put(errCode, Integer.toString(0));
        result.put(errMsg, "登录成功");
        if(channel != null){
          channel.invokeMethod("onLoginSuccessRes", result);
        }
      }

      @Override
      public void onLoginFail(int code, String msg) {
        Log.i(TAG, "on Login Fail.");

        Map result = new HashMap<>();
        result.put(errCode,code);
        result.put(errMsg, msg);

        if(channel != null){
          channel.invokeMethod("onLoginFailRes", result);
        }
      }

      @Override
      public void onRefreshToken(String token) {
        Log.i(TAG, "on Refresh Token." + token);

        Map result = new HashMap<>();
        result.put(errCode, 0);
        result.put(mtoken, token);
        result.put(errMsg, "success");

        if(channel != null){
          channel.invokeMethod("onRefrshToken", result);
        }
      }
    });
  }
  public void getGameList(MethodCall call, Result result){
    CFGameSDK.getGameList(new ICFGameListCallback() {

      @Override
      public void onSuccess(List<CFGameList.GameInfo> gameList) {
        Log.i(TAG, "get Game List success.");

        List<Map> newGameList = new ArrayList<Map>();
        if (!gameList.isEmpty()) {
          for (CFGameList.GameInfo gameInfo : gameList) {
              Map map =  new HashMap<>();
              map.put("g_id",gameInfo.g_id);
              map.put("g_name",gameInfo.g_name);
              map.put("g_icon",gameInfo.g_icon);
              map.put("g_url",gameInfo.g_url);
              newGameList.add(map);
          }
        }


        Map result = new HashMap<>();
        result.put(errCode, 0);
        result.put(mgameList, newGameList);

        Log.i(TAG, "get Game List success." + result);
        if(channel != null){
          channel.invokeMethod("onGetGameSuccess", result);
        }
      }

      @Override
      public void onError(int code, String errorMsg) {
        Map result = new HashMap<>();
        result.put(errCode, code);
        result.put(errMsg, errorMsg);

        if(channel != null){
          channel.invokeMethod("onGetGameFail", result);
        }
      }
    });
  }

  public void releaseSDK(MethodCall call, Result result){

    CFGameSDK.releaseSDK();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
