part of 'chat_message_bloc.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object> get props => [];
}

class MessageLoadingState extends ChatMessageState {}

class MessageLoadedState extends ChatMessageState {
  final ScrollController scrollController;
  final TextEditingController textController;
  final FocusNode focusNode;
  final Stream<QuerySnapshot<MessageModel>> chatStream;

  const MessageLoadedState({
    required this.scrollController,
    required this.textController,
    required this.focusNode,
    required this.chatStream,
  });

  @override
  List<Object> get props => [
        scrollController,
        textController,
        focusNode,
      ];
}
