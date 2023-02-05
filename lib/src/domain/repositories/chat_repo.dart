import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:flutter/material.dart';

abstract class FirebaseChatRepo {
  Future<void> viewChat({
    required UserDataModel userDataModel,
    required BuildContext context,
  });
  
  Future<void> sendMessage({
    required MessageModel messageModel,
    required String chatId,
  });
}
