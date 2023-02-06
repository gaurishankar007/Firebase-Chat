import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/data/argument/chat_message_arg.dart';
import 'package:firebase_chat/src/data/remote/models/google_user_model.dart';
import 'package:firebase_chat/src/data/remote/models/chat_model.dart';
import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/domain/repositories/chat_repo.dart';

import '../../local/local_data.dart';

class FirebaseChatRepoImpl extends FirebaseChatRepo {
  final _database = FirebaseFirestore.instance;
  final GoogleUserModel googleUserModel = LocalData.googleUserModel!;

  @override
  Future<void> viewChat(
      {required UserDataModel userDataModel,
      required BuildContext context}) async {
    final fromMessage = await _database
        .collection("chat")
        .withConverter(
          fromFirestore: ChatModel.fromFirestore,
          toFirestore: (ChatModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .where("fromId", isEqualTo: googleUserModel.accessToken)
        .where("toId", isEqualTo: userDataModel.id)
        .get();

    final toMessage = await _database
        .collection("chat")
        .withConverter(
          fromFirestore: ChatModel.fromFirestore,
          toFirestore: (ChatModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .where("fromId", isEqualTo: userDataModel.id)
        .where("toId", isEqualTo: googleUserModel.accessToken)
        .get();

    if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
      final ChatModel messageModel = ChatModel(
        fromId: googleUserModel.accessToken,
        toId: userDataModel.id,
        fromName: googleUserModel.displayName,
        toName: userDataModel.name,
        fromAvatar: googleUserModel.photoUrl,
        toAvatar: userDataModel.photoUrl,
        lastMsg: "",
        lastTime: Timestamp.now(),
        msgNum: 0,
      );

      final newMessage = await _database
          .collection("chat")
          .withConverter(
            fromFirestore: ChatModel.fromFirestore,
            toFirestore: (ChatModel messageModel, options) =>
                messageModel.toFirestore(),
          )
          .add(messageModel);

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          "/chatMessage",
          arguments: ChatMessageArg(
            chatId: newMessage.id,
            toId: userDataModel.id,
            toName: userDataModel.name,
            toAvatar: userDataModel.photoUrl,
          ),
        );
      }
    } else {
      late String chatId;

      if (fromMessage.docs.isNotEmpty) {
        chatId = fromMessage.docs.first.id;
      } else {
        chatId = toMessage.docs.first.id;
      }

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          "/chatMessage",
          arguments: ChatMessageArg(
            chatId: chatId,
            toId: userDataModel.id,
            toName: userDataModel.name,
            toAvatar: userDataModel.photoUrl,
          ),
        );
      }
    }
  }

  @override
  Future<void> sendMessage({
    required MessageModel messageModel,
    required String chatId,
  }) async {
    await _database
        .collection("chat")
        .doc(chatId)
        .collection("message")
        .withConverter(
          fromFirestore: MessageModel.fromFirestore,
          toFirestore: (MessageModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .add(messageModel);

    await _database.collection("chat").doc(chatId).update({
      "lastMsg": messageModel.content,
      "lastTime": Timestamp.now(),
    });
  }
}
