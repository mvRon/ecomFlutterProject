import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final UserService _userService = UserService();
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser(String uid) async {
    _isLoading = true;
    notifyListeners();
    _user = await _userService.getUser(uid);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    await _userService.saveUser(user);
    _user = user;
    _isLoading = false;
    notifyListeners();
  }
}

