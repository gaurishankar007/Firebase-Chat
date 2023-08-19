import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constant.dart';
import '../../local/local_data.dart';
import '../models/google_user_model.dart';
import '../models/user_model.dart';
import '../../../domain/repositories/auth_repo.dart';
import '../../../presentation/widgets/messages/message.dart';

class AuthRepo implements FirebaseAuthRepo {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['openid'],
  );
  final _firebaseAuth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  @override
  Future<void> googleSignIn({required BuildContext context}) async {
    try {
      final googleUserData = await _googleSignIn.signIn();

      if (googleUserData != null) {
        late MessageController loading;
        if (context.mounted) {
          loading = MessageScreen.message().showLoading(
            context: context,
            message: "Just a moment, you're being signed in...",
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
          ),
        );

        final userData = await _database
            .collection("users")
            .withConverter(
              fromFirestore: UserDataModel.fromFireStore,
              toFirestore: (UserDataModel userData, options) =>
                  userData.toFirestore(),
            )
            .where("id", isEqualTo: id)
            .get();

        if (userData.docs.isEmpty) {
          final UserDataModel userDataModel = UserDataModel(
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
                fromFirestore: UserDataModel.fromFireStore,
                toFirestore: (UserDataModel userData, options) =>
                    userData.toFirestore(),
              )
              .add(userDataModel);
        }

        final gAuthentication = await googleUserData.authentication;

        await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: gAuthentication.idToken,
          accessToken: gAuthentication.accessToken,
        ));

        loading.close();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);

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
    } catch (e) {
      MessageScreen.message().show(
        context: context,
        message: e.toString(),
        type: MessageType.error,
      );
    }
  }

  @override
  Future<void> signOut({required BuildContext context}) async {
    LocalData.removeUser();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/signIn", (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "You have been signed out.",
            style: smallBoldText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
