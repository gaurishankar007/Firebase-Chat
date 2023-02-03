import 'package:firebase_chat/src/core/resources/data_state.dart';

import '../../data/remote/models/user_model.dart';

abstract class FirebaseUserRepo {
  Future<DataState<List<UserDataModel>>>? loadUsers();
}
