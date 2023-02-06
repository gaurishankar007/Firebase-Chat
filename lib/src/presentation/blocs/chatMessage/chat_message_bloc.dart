import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/data/remote/repositories/chat_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final Stream<QuerySnapshot<MessageModel>> chatStream;

  ChatMessageBloc() : super(MessageLoadingState()) {
    on<MessageLoadedEvent>(_messageLoadedEvent);
    on<SendMessageEvent>(_sendMessage);
  }

  _messageLoadedEvent(MessageLoadedEvent event, emit) async {
    chatStream = FirebaseFirestore.instance
        .collection("chat")
        .doc(event.chatId)
        .collection("message")
        .withConverter(
          fromFirestore: MessageModel.fromFirestore,
          toFirestore: (MessageModel messageModel, options) =>
              messageModel.toFirestore(),
        )
        .orderBy("createdAt", descending: true)
        .snapshots();

    emit(MessageLoadedState(
      scrollController: scrollController,
      textController: textController,
      focusNode: focusNode,
      chatStream: chatStream,
    ));
  }

  _sendMessage(SendMessageEvent event, emit) async {
    await FirebaseChatRepoImpl().sendMessage(
      messageModel: event.messageModel,
      chatId: event.chatId,
    );

    textController.clear();
    focusNode.unfocus();

    emit(MessageLoadedState(
      scrollController: scrollController,
      textController: textController,
      focusNode: focusNode,
      chatStream: chatStream,
    ));
  }
}
