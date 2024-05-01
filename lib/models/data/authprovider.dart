import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  Map<String, dynamic>? _userData;

  void saveLoginDetails(Map<String, dynamic> loginData) {
    _token = loginData['token'];
    _refreshToken = loginData['refreshToken'];
    _userData = loginData['userData'];
    notifyListeners();
  }

  void logout() {
    _token = null;
    _refreshToken = null;
    _userData = null;
    // Add any other reset logic here if needed
    notifyListeners();
  }

  String? get token => _token;
  String? get refreshToken => _refreshToken;
  Map<String, dynamic>? get userData => _userData;
}
