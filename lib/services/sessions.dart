// packages
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// models
import '../models/user.dart';

class SessionManager {
  static const _userKey = 'current_user';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return UserModel.fromMap(jsonDecode(userString));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
