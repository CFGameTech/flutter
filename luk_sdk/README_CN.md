# luk_sdk

## 什么是luk_sdk

`luk_sdk` 是一个接入[LUKSDK](https://www.luk.live/developer)插件，它允许开发者调用[LUKSDK]

## 能力
- 实现接入[LUKSDK]初始化方法
- 实现接入[LUKSDK]登录方法
- 实现获取[LUKSDK]游戏列表
- 实现拉起flutter游戏webview

## 安装

在`pubspec.yaml` 文件中添加`luk_sdk`依赖:

```yaml
dependencies:
  luk_sdk: ^${latestVersion}
```

## 使用
- [初始化] 
- _lukSdkPlugin.setupSDK(appId, language, isProduct);
  appId = 在[LUKSDK]后台配置的渠道id
  language = 根据所需的语言填入对应的字符串（可以参考(https://wiki.luk.live/zh/language_list)）
  isProduct = 测试环境填入 false， 正式环境填入 true
- 初始化只是基参数设置，不设置回调

- [登录]
- _lukSdkPlugin.setUserInfo(userId, userCode);
  userId = 渠道方用户id
  userCode = 渠道方用户code
- 回调LukOnRefrshTokenRes

- [获取游戏列表] 
- _lukSdkPlugin.getGameList();
- 回调LukOnGetGameListRes
  `游戏列表数组 response.gameList `
  `[{g_id:"gameID",g_name:"gameName",g_icon:"gameIcon",g_url:"gameUrl"}]`
  `g_id:游戏id ， g_name:游戏名称 ， g_icon:游戏图标， g_url:游戏链接`

- [游戏webview]
- LukGameView
- 插件中的LukGameView是一个实现了加载游戏链接的webView控件
- 实现了游戏中会使用到的回调以及接口
- 可以参考demo中的luk_game_dialog.dart和luk_game_page.dart，也可以由接入方自主调整使用

- [接口回调]
- LukSDKResponse
- 可以在代码中监听LukSDKResponse，在不同的response中监听不同的接口状态，可参考demo中的实现方式