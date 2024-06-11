import 'package:flutter/material.dart';
import 'package:sweater/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(String email, String password) {
    // 실제 로그인 로직을 추가하세요
    if (email == 'test@test.com' && password == 'password') {
      _user = User(email: email, password: password);
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  void signUp(String email, String password) {
    // 실제 회원가입 로직을 추가하세요
    _user = User(email: email, password: password);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
