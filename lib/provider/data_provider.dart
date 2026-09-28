import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

enum DataState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class DataProvider extends ChangeNotifier {
  final ApiService _apiService =
      ApiService();

  DataState _state =
      DataState.initial;

  List<UserModel> _users = [];

  String? _errorMessage;

  DataState get state => _state;

  List<UserModel> get users => _users;

  String? get errorMessage =>
      _errorMessage;

  Future<void> fetchUsers() async {
    _state = DataState.loading;
    _errorMessage = null;

    notifyListeners();

    try {
      final users =
          await _apiService.fetchUsers();

      _users = users;

      if (_users.isEmpty) {
        _state = DataState.empty;
      } else {
        _state = DataState.loaded;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = DataState.error;
    }

    notifyListeners();
  }
}