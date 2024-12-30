import 'package:flutter/cupertino.dart';

mixin LukCancelable{
  void cancel();
}

class LukCancelableImpl implements LukCancelable{

  const LukCancelableImpl({required this.onCancel});

  final VoidCallback onCancel;

  @override
  void cancel(){
    onCancel();
  }
}