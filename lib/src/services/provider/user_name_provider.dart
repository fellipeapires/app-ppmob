import 'package:flutter/material.dart';

class UserNameProvider with ChangeNotifier {
  String? _username;

  String? get username => _username;

  void setUsername(String? username) {
    if (_username != username) {
      _username = username;
      notifyListeners();
    }
  }
}
