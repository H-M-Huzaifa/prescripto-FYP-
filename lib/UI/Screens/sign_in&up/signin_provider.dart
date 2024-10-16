import 'package:flutter/cupertino.dart';

class class_sign_in_provider with ChangeNotifier{
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;


  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }


}