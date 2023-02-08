import 'dart:io';

import 'package:firebase_chat/src/core/resources/data_state.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:flutter/material.dart';

abstract class FirebaseChatRepo {
  Future<void> viewChat({
    required UserDataModel userDataModel,
    required BuildContext context,
  });

  Future<DataState>? sendMessage({
    required MessageModel messageModel,
    required String chatId,
  });

  Future<DataState>? sendImage({
    required String uId,
    required File image,
    required String chatId,
  });
}
