import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/data/remote/models/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/local/local_data.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final fromChat = FirebaseFirestore.instance
      .collection("chat")
      .withConverter(
        fromFirestore: ChatModel.fromFireStore,
        toFirestore: (ChatModel messageModel, options) =>
            messageModel.toFirestore(),
      )
      .where("fromId", isEqualTo: LocalData.googleUserModel!.accessToken)
      .orderBy("lastTime", descending: true)
      .snapshots();

  final toChat = FirebaseFirestore.instance
      .collection("chat")
      .withConverter(
        fromFirestore: ChatModel.fromFireStore,
        toFirestore: (ChatModel messageModel, options) =>
            messageModel.toFirestore(),
      )
      .where("toId", isEqualTo: LocalData.googleUserModel!.accessToken)
      .orderBy("lastTime")
      .snapshots();

  List<DocumentSnapshot<ChatModel>> chatModels = [];

  ChatListBloc() : super(ChatListLoadingState()) {
    fromChat.listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            final tempChatModel = change.doc;
            if (tempChatModel.data() != null) {
              chatModels.insert(0, tempChatModel);
            }
            break;
          case DocumentChangeType.modified:
            final tempChatModel = change.doc;
            chatModels.removeWhere((element) => element.id == tempChatModel.id);
            if (tempChatModel.data() != null) {
              chatModels.insert(0, tempChatModel);
            }
            break;
          case DocumentChangeType.removed:
            break;
        }
      }

      chatModels.sort((a, b) {
        return b
            .data()!
            .lastTime
            .toDate()
            .compareTo(a.data()!.lastTime.toDate());
      });
      add(ChatListAddedEvent());
    });

    toChat.listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            final tempChatModel = change.doc;
            if (tempChatModel.data() != null) {
              chatModels.insert(0, tempChatModel);
            }
            break;
          case DocumentChangeType.modified:
            final tempChatModel = change.doc;
            chatModels.removeWhere((element) => element.id == tempChatModel.id);
            if (tempChatModel.data() != null) {
              chatModels.insert(0, tempChatModel);
            }
            break;
          case DocumentChangeType.removed:
            break;
        }
      }

      chatModels.sort((a, b) {
        return b
            .data()!
            .lastTime
            .toDate()
            .compareTo(a.data()!.lastTime.toDate());
      });
      add(ChatListAddedEvent());
    });

    on<ChatListAddedEvent>(_chatListAddedEvent);
  }

  _chatListAddedEvent(ChatListAddedEvent event, emit) {
    emit(ChatListLoadedState(chatModels: chatModels));
  }
}
