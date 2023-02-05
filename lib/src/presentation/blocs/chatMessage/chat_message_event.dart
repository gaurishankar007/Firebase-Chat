part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatMessageEvent {
  final MessageModel messageModel;
  final String chatId;

  const SendMessageEvent({
    required this.messageModel,
    required this.chatId,
  });
}
