import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userLanguage;
  bool _isLoggedIn = false;

  // Getters
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userLanguage => _userLanguage;
  bool get isLoggedIn => _isLoggedIn;

  // Set user data
  void setUser(String id, String name, String language) {
    _userId = id;
    _userName = name;
    _userLanguage = language;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Logout
  void logout() {
    _userId = null;
    _userName = null;
    _userLanguage = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Update language
  void updateLanguage(String language) {
    _userLanguage = language;
    notifyListeners();
  }
}