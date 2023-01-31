import 'package:firebase_chat/src/presentation/screens/home.dart';

import '../../presentation/screens/auth/sign_in.dart';
import '../../presentation/screens/auth/welcome.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String welcome = "/welcome";
  static const String home = "/home";

  static Route? onGenerated(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _materialRoute(page: Welcome());

      case "/signIn":
        return _materialRoute(page: SignIn());

      case home:
        return _materialRoute(page: Home());

      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute({required Widget page}) {
    return MaterialPageRoute(builder: (builder) => page);
  }
}
