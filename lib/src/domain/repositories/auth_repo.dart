import 'package:flutter/material.dart';

abstract class FirebaseAuthRepo {
  Future<void>? googleSignIn(BuildContext context);
  Future<void>? signOut(BuildContext context);
}
