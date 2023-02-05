import 'package:flutter/material.dart';

abstract class FirebaseAuthRepo {
  Future<void>? googleSignIn({required BuildContext context});
  Future<void>? signOut({required BuildContext context});
}
