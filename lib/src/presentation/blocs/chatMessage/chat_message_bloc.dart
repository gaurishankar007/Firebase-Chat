import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/core/resources/data_state.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/data/remote/repositories/chat_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant.dart';
import '../../widgets/messages/message.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final ImagePicker imagePicker = ImagePicker();
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final Stream<QuerySnapshot<MessageModel>> chatStream;

  final BuildContext context;

  ChatMessageBloc({required this.context}) : super(MessageLoadingState()) {
    on<MessageLoadedEvent>(_messageLoadedEvent);
    on<SendMessageEvent>(_sendMessage);
    on<SendImageEvent>(_sendImage);
  }

  _messageLoadedEvent(MessageLoadedEvent event, emit) async {
    chatStream = FirebaseFirestore.instance
        .collection("chat")
        .doc(event.chatId)
        .collection("message")
        .withConverter(
          fromFirestore: MessageModel.fromFireStore,
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
    textController.clear();
    focusNode.unfocus();

    final dataState = await FirebaseChatRepoImpl().sendMessage(
      messageModel: event.messageModel,
      chatId: event.chatId,
    );

    if (dataState is DataFailed && context.mounted) {
      MessageScreen.message().show(
        context: context,
        message: "Could not send message, error occurred.",
        type: MessageType.error,
      );
    } else if (dataState is ServerTimeOut && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No Internet.",
            style: smallBoldText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    emit(MessageLoadedState(
      scrollController: scrollController,
      textController: textController,
      focusNode: focusNode,
      chatStream: chatStream,
    ));
  }

  _sendImage(SendImageEvent event, emit) async {
    final XFile? imageXFile =
        await imagePicker.pickImage(source: event.imageSource);
    if (imageXFile == null) return;

    File imageFile = File(imageXFile.path);
    final dataState = await FirebaseChatRepoImpl().sendImage(
      uId: event.uId,
      image: imageFile,
      chatId: event.chatId,
    );

    if (dataState is DataFailed && context.mounted) {
      MessageScreen.message().show(
        context: context,
        message: "Could not send image, error occurred.",
        type: MessageType.error,
      );
    } else if (dataState is ServerTimeOut && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No Internet.",
            style: smallBoldText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
