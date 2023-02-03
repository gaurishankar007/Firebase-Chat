import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/core/resources/data_state.dart';
import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/domain/repositories/user_repo.dart';

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
            fromFirestore: UserDataModel.fromFirestore,
            toFirestore: (UserDataModel userData, options) =>
                userData.toFirestore(),
          )
          .get();

      return DataSuccess(data: users.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      return DataFailed(error: e.toString());
    }
  }
}
