import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/data/remote/models/google_user_model.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/domain/repositories/firebase_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepoImpl implements FirebaseRepo {
  final db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['openid'],
  );

  @override
  Future<void> googleSignIn() async {
    try {
      final googleUserData = await _googleSignIn.signIn();

      if (googleUserData != null) {
        String id = googleUserData.id;
        String displayName = googleUserData.displayName ?? googleUserData.email;
        String email = googleUserData.email;
        String photoUrl = googleUserData.photoUrl ?? "";

        GoogleUserModel googleUser = GoogleUserModel(
          accessToken: id,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
        );

        LocalData().saveUser(googleUser: googleUser);

        final userData = await db
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

          await db
              .collection("users")
              .withConverter(
                fromFirestore: UserDataModel.fromFirestore,
                toFirestore: (UserDataModel userData, options) =>
                    userData.toFirestore(),
              )
              .add(data);
        }
      }
    } catch (e) {}
  }
}
