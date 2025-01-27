import 'package:flutter/material.dart';

class StatusUserProvider with ChangeNotifier {
  String? _statususer;

  String? get statususer => _statususer;

  void setStatusUser(String? statususer) {
    if (_statususer != statususer) {
      _statususer = statususer;
      notifyListeners();
    }
  }
}
