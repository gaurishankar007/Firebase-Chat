import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/core/resources/data_state.dart';
import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/domain/repositories/user_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseUserRepoImpl extends FirebaseUserRepo {
  final _database = FirebaseFirestore.instance;
  final String token = LocalData.googleUserModel!.accessToken;

  @override
  Future<DataState<List<UserDataModel>>> loadUsers() async {
    try {
      final users = await _database
          .collection("users")
          .where("id", isNotEqualTo: token)
          .withConverter(
            fromFirestore: UserDataModel.fromFireStore,
            toFirestore: (UserDataModel userData, options) =>
                userData.toFirestore(),
          )
          .limit(20)
          .get();

      return DataSuccess(data: users.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      return DataFailed(error: e.toString());
    }
  }

  @override
  Future<DataState<List<UserDataModel>>> searchUsers(
      {required String name}) async {
    try {
      final users = await _database
          .collection("users")
          .where("name", isEqualTo: name)
          .withConverter(
            fromFirestore: UserDataModel.fromFireStore,
            toFirestore: (UserDataModel userData, options) =>
                userData.toFirestore(),
          )
          .limit(20)
          .get();

      final List<UserDataModel> usersModels = [];

      for (var doc in users.docs) {
        if (doc.data().id != token) {
          usersModels.add(doc.data());
        }
      }

      return DataSuccess(data: usersModels);
    } on SocketException {
      return ServerTimeOut();
    } catch (e) {
      return DataFailed(error: e.toString());
    }
  }

  Future<void> getFcmToken() async {
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final user = await _database
          .collection("user")
          .where("id", isEqualTo: token)
          .get();

      if (user.docs.isEmpty) return;
      final String userId = user.docs.first.id;
      await _database
          .collection("users")
          .doc(userId)
          .update({"fcmToken": fcmToken});
    }
  }
}
