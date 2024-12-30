#import "LukSdkPlugin.h"
#import <CFGameSDK/CFGameSDK.h>
#import <CFGameSDK/CFGameModel.h>

@interface LukSdkPlugin() <CFGameSDKLoginDelegate>


@end



@implementation LukSdkPlugin {
    FlutterMethodChannel *_channel;
}

const NSString *_errCode = @"code";
const NSString *_token = @"token";
const NSString *_msg   = @"msg";
const NSString *_gameList = @"gameList";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"luk_sdk"
            binaryMessenger:[registrar messenger]];
  LukSdkPlugin* instance = [[LukSdkPlugin alloc] initWithChannel:channel];
  [registrar addMethodCallDelegate:instance channel:channel];


}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS" stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"setupSDK" isEqualToString:call.method]){
      [self setupSDK:call result:result];
  }else if([@"setUserInfo" isEqualToString:call.method]){
      [self setUserInfo:call result:result];
  }else if([@"getGameList" isEqualToString:call.method]) {
      [self getGameList];
  }else if([@"releaseSDK" isEqualToString:call.method]) {
      [self releaseSDK];
  }else{
    result(FlutterMethodNotImplemented);
  }
}


// 初始化方法
- (void)setupSDK:(FlutterMethodCall*)call result:(FlutterResult)result{

    NSString *appid = call.arguments[@"appId"];
    NSString *language = call.arguments[@"language"];
    BOOL isProduct = [call.arguments[@"isProduct"] boolValue];

    NSLog(@"userid %@,usercode %@ isProduct %d",appid,language,isProduct);

    [CFGameSDK setUpSDKWithApplication:UIApplication.sharedApplication appId:appid language:language isProduct:isProduct];

}



//  登录方法
- (void)setUserInfo:(FlutterMethodCall *)call result:(FlutterResult)result{

    NSString *userId = call.arguments[@"userId"];
    NSString *userCode = call.arguments[@"userCode"];

    NSLog(@"userid %@,usercode %@",userId,userCode);
    [CFGameSDK setUserInfo:userId code:userCode loginCallBack:self];
}


#pragma mark -- CFGameSDKLoginDelegate

//  用户登录失败回调
- (void)onLoginFailCode:(int)code message:(NSString *)msg {
    NSLog(@"登录失败");
    NSDictionary *result = @{
        _errCode:@(code),_msg:msg};

    if(_channel != nil){
        [_channel invokeMethod:@"onLoginFailRes" arguments:result];
    }
}

//  用户登录成功回调
- (void)onLoginSuccess {
    NSLog(@"登录成功");
    NSDictionary *result = @{
            _errCode:@(0),_msg:@"登录成功"
    };

    if(_channel != nil){
        [_channel invokeMethod:@"onLoginSuccessRes" arguments:result];
    }
}

//  token更新后回调，接入方通常无需关注此接口
- (void)onRefreshToken:(NSString *)token {
    NSLog(@"refresh token %@",token);
    NSDictionary *result = @{_errCode:@(0),_token:token};
    
    if(_channel != nil){
        [_channel invokeMethod:@"onRefrshToken" arguments:result];
    }
}

- (void)getGameList{
    NSLog(@"getGameList");
    [CFGameSDK getGameListWithSuccess:^(NSArray<CFGameModel *> * _Nonnull gameList) {
    
        NSLog(@"getGameList success");
        
        if (gameList && gameList.count > 0) {
            
            NSMutableArray *gameArr = [NSMutableArray array];
            for (CFGameModel *Model in gameList) {
                NSDictionary *dict = @{@"g_id":@(Model.g_id),
                                       @"g_name":Model.g_name,
                                       @"g_icon":Model.g_icon,
                                       @"g_url":Model.g_url};
                [gameArr addObject:dict];
            }
            NSArray *gameNewArr = [NSArray arrayWithArray:gameArr];

            NSDictionary *result = @{_errCode:@(0),_msg:@"success",_gameList:gameNewArr};

            if(self->_channel != nil){
                [self->_channel invokeMethod:@"onGetGameSuccess" arguments:result];
            }
        }else{
            if(self->_channel != nil){
                NSDictionary *result = @{_errCode:@(999),_msg:@"list is null"};
                [self->_channel invokeMethod:@"onGetGameFail" arguments:result];
            }
        }
        
        
    } failure:^(int code, NSString * _Nonnull msg) {
        NSLog(@"getGameList fail %@",msg);
        if(self->_channel != nil){
            NSDictionary *result = @{_errCode:@(code),_msg:msg};
            [self->_channel invokeMethod:@"onGetGameFail" arguments:result];
        }
    }];
    
}

- (void)releaseSDK{
    [CFGameSDK releaseSDK];
}










@end
