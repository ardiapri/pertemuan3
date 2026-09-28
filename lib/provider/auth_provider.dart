import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated =>
      _isAuthenticated;

  String? get token => _token;

  Future<bool> login(
    String email,
    String password,
  ) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (email.isEmpty ||
        password.isEmpty) {
      return false;
    }

    if (password.length < 6) {
      return false;
    }

    _token = 'dummy_token_12345';
    _isAuthenticated = true;

    notifyListeners();

    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _token = null;

    notifyListeners();
  }
}