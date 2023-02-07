part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}

class MessageLoadedEvent extends ChatMessageEvent {
  final String chatId;

  const MessageLoadedEvent({required this.chatId});
}

class SendMessageEvent extends ChatMessageEvent {
  final MessageModel messageModel;
  final String chatId;

  const SendMessageEvent({
    required this.messageModel,
    required this.chatId,
  });
}

class SendImageEvent extends ChatMessageEvent {
  final String uId;
  final ImageSource imageSource;
  final String chatId;

  const SendImageEvent({
    required this.uId,
    required this.imageSource,
    required this.chatId,
  });
}
