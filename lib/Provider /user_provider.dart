
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProvider extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    notifyListeners();
  }

  Future<void> setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    _userId = id;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    _userId = null;
    notifyListeners();
  }
}