import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constant.dart';
import '../../local/local_data.dart';
import '../models/google_user_model.dart';
import '../models/user_model.dart';
import '../../../domain/repositories/firebase_repo.dart';
import '../../../presentation/widgets/messages/message.dart';

class FirebaseAuthRepoImpl implements FirebaseAuthRepo {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['openid'],
  );
  final _firebaseAuth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> googleSignIn(BuildContext context) async {
    try {
      final googleUserData = await _googleSignIn.signIn();

      if (googleUserData != null) {
        late MessageController loading;
        if (context.mounted) {
          loading = MessageScreen.message().showLoading(
            context: context,
            message: "Please wait while we're signing you in...",
          );
        }

        String id = googleUserData.id,
            displayName = googleUserData.displayName ?? googleUserData.email,
            email = googleUserData.email,
            photoUrl = googleUserData.photoUrl ?? "";

        LocalData.saveUser(
            googleUser: GoogleUserModel(
          accessToken: id,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
        ));

        final userData = await _database
            .collection("users")
            .withConverter(
              fromFirestore: UserDataModel.fromFirestore,
              toFirestore: (UserDataModel userData, options) =>
                  userData.toFirestore(),
            )
            .where("id", isEqualTo: id)
            .get();

        if (userData.docs.isEmpty) {
          final data = UserDataModel(
            id: id,
            name: displayName,
            email: email,
            photoUrl: photoUrl,
            location: "",
            fcmToken: "",
            createdAt: Timestamp.now(),
          );

          await _database
              .collection("users")
              .withConverter(
                fromFirestore: UserDataModel.fromFirestore,
                toFirestore: (UserDataModel userData, options) =>
                    userData.toFirestore(),
              )
              .add(data);
        }

        loading.close();

        final gAuthentication = await googleUserData.authentication;

        await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: gAuthentication.idToken,
          accessToken: gAuthentication.accessToken,
        ));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Login Success",
                style: smallBoldText.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        MessageScreen.message().show(
          context: context,
          message: "User does not exist.",
        );
      }
    } catch (e) {
      MessageScreen.message().show(
        context: context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  @override
  Future<void> signOut(BuildContext context) async {
    LocalData.removeUser();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/signIn", (route) => false);
    }
  }
}
