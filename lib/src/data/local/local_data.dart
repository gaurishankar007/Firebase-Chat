import 'dart:convert';

import 'package:firebase_chat/src/config/routes/route.dart';

import '../remote/models/google_user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences _sharedPref;
  static GoogleUserModel? _googleUserModel;

  static Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();

    String? userData = _sharedPref.getString("userData");

    if (userData != null) {
      _googleUserModel = GoogleUserModel.fromJson(jsonDecode(userData));
    }
  }

  static ThemeMode getThemeMode() => _sharedPref.getBool("darkMode") == true
      ? ThemeMode.dark
      : ThemeMode.light;

  static addThemeMode({required ThemeMode themeMode}) =>
      _sharedPref.setBool("darkMode", themeMode == ThemeMode.dark);

  static GoogleUserModel? get googleUserModel => _googleUserModel;

  static String initialRoute() => _sharedPref.getString("userData") == null
      ? AppRoutes.welcome
      : AppRoutes.home;

  static saveUser({required GoogleUserModel googleUser}) {
    _sharedPref.setString("userData", jsonEncode(googleUser.toJson()));
  }

  static removeUser() => _sharedPref.remove("userData");
}
