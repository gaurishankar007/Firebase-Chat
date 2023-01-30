import 'package:firebase_chat/src/presentation/screens/auth/sign_in.dart';
import 'package:firebase_chat/src/presentation/screens/welcome.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String welcome = "/welcome";
  static const String signIn = "/signIn";

  static Route? onGenerated(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _materialRoute(page: Welcome());

      case signIn:
        return _materialRoute(page: SignIn());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute({required Widget page}) {
    return MaterialPageRoute(builder: (builder) => page);
  }
}
