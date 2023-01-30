import 'dart:convert';

import 'package:firebase_chat/src/config/routes/route.dart';
import 'package:firebase_chat/src/data/remote/models/google_user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences _sharedPref;
  String _token = "";

  static Future<void> setInstance() async =>
      _sharedPref = await SharedPreferences.getInstance();

  static ThemeMode getThemeMode() => _sharedPref.getBool("darkMode") == true
      ? ThemeMode.dark
      : ThemeMode.light;

  static addThemeMode({required ThemeMode themeMode}) =>
      _sharedPref.setBool("darkMode", themeMode == ThemeMode.dark);

  static appOpened() => _sharedPref.setBool("appOpened", true);

  static String get initialRoute => _sharedPref.getBool("appOpened") == true
      ? AppRoutes.signIn
      : AppRoutes.welcome;

  String get userToken => _token;

  Future<void> saveUser({required GoogleUserModel googleUser}) async {
    _sharedPref.setString("userData", jsonEncode(googleUser.toJson()));
    _sharedPref.setString("userToken", googleUser.accessToken);
    _token = googleUser.accessToken;
  }
}
