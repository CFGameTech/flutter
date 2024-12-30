


const String _msg = 'msg';
const String _code = 'code';
typedef LukSDKResponseSubscriber = void Function(LukSDKResponse response);
typedef _LukSDKResponseInvoker = LukSDKResponse Function(Map argument);

Map<String, _LukSDKResponseInvoker> _nameAndResponseMapper = {
  'onRefrshToken': (Map argument) => LukOnRefrshTokenRes.fromMap(argument) ,
  'onGetGameList':  (Map argument) => LukOnGetGameListRes.fromMap(argument) ,


};


sealed class LukSDKResponse{
  LukSDKResponse._( this.code, this.msg);

  factory LukSDKResponse.create(String name, Map argument){
    var result = _nameAndResponseMapper[name];
    if (result == null) {
      throw ArgumentError("Can't found instance of $name");
    }
    return result(argument);
  }

  final String? msg;
  final int? code;

  bool get isSuccessful => code == 0;

  Record toRecord() {
    return ();
  }
}


class LukOnRefrshTokenRes extends LukSDKResponse{
  String? token;
  LukOnRefrshTokenRes.fromMap(Map map)
    :token = map["token"],
    super._(map[_code],map[_msg]);


  @override
  Record toRecord(){
    return (code: code, msg: msg, token: token);
  }
}

class LukOnGetGameListRes extends LukSDKResponse{
  List<dynamic>? gameList;
  LukOnGetGameListRes.fromMap(Map map)
    :gameList = map["gameList"],
    super._(map[_code],map[_msg]);

  @override
  Record toRecord(){
    return (code: code, msg: msg, gameList:gameList);
  }
}

