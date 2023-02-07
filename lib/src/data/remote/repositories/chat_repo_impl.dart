import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_chat/src/core/resources/data_state.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/domain/entities/message_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<DataState<List<ChatModel>>> chatList() async {
    try {
      final fromChat = await _database
          .collection("chat")
          .withConverter(
            fromFirestore: ChatModel.fromFirestore,
            toFirestore: (ChatModel messageModel, options) =>
                messageModel.toFirestore(),
          )
          .where("fromId", isEqualTo: googleUserModel.accessToken)
          .get();

      final toChat = await _database
          .collection("chat")
          .withConverter(
            fromFirestore: ChatModel.fromFirestore,
            toFirestore: (ChatModel messageModel, options) =>
                messageModel.toFirestore(),
          )
          .where("toId", isEqualTo: googleUserModel.accessToken)
          .get();

      List<ChatModel> chatModels = [];
      if (fromChat.docs.isNotEmpty) {
        chatModels.addAll(fromChat.docs.map((doc) => doc.data()).toList());
      }
      if (toChat.docs.isNotEmpty) {
        chatModels.addAll(toChat.docs.map((doc) => doc.data()).toList());
      }

      return DataSuccess(data: chatModels);
    } on SocketException {
      return ServerTimeOut();
    } catch (error) {
      return DataFailed(error: error.toString());
    }
  }

  @override
  Future<void> viewChat(
      {required UserDataModel userDataModel,
      required BuildContext context}) async {
    final fromChat = await _database
        .collection("chat")
        .withConverter(
          fromFirestore: ChatModel.fromFirestore,
          toFirestore: (ChatModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .where("fromId", isEqualTo: googleUserModel.accessToken)
        .where("toId", isEqualTo: userDataModel.id)
        .get();

    final toChat = await _database
        .collection("chat")
        .withConverter(
          fromFirestore: ChatModel.fromFirestore,
          toFirestore: (ChatModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .where("fromId", isEqualTo: userDataModel.id)
        .where("toId", isEqualTo: googleUserModel.accessToken)
        .get();

    if (fromChat.docs.isEmpty && toChat.docs.isEmpty) {
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

      if (fromChat.docs.isNotEmpty) {
        chatId = fromChat.docs.first.id;
      } else {
        chatId = toChat.docs.first.id;
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
  Future<DataState> sendMessage(
      {required MessageModel messageModel, required String chatId}) async {
    try {
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

      return DataSuccess(data: "success");
    } on SocketException {
      return ServerTimeOut();
    } catch (error) {
      return DataFailed(error: error.toString());
    }
  }

  @override
  Future<DataState> sendImage(
      {required String uId,
      required File image,
      required String chatId}) async {
    try {
      var random = Random.secure();
      var values = List<int>.generate(10, (i) => random.nextInt(255));
      final String fileName =
          base64UrlEncode(values) + DateTime.now().toIso8601String();

      final Reference ref =
          FirebaseStorage.instance.ref("messageFile").child(fileName);
      await ref.putFile(image);
      final imageDownloadURL = await ref.getDownloadURL();

      final MessageModel messageModel = MessageModel(
        uId: uId,
        content: imageDownloadURL,
        type: MessageType.image,
        createdAt: Timestamp.now(),
      );

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
        "lastMsg": "[image]",
        "lastTime": Timestamp.now(),
      });

      return DataSuccess(data: "success");
    } on SocketException {
      return ServerTimeOut();
    } catch (error) {
      return DataFailed(error: error.toString());
    }
  }
}
