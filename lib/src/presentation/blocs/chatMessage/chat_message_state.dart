part of 'chat_message_bloc.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object> get props => [];
}

class ChatMessageInitial extends ChatMessageState {}

class ChatMessageLoaded extends ChatMessageState {
  final ScrollController scrollController;
  final TextEditingController textController;
  final FocusNode focusNode;

  const ChatMessageLoaded({
    required this.scrollController,
    required this.textController,
    required this.focusNode,
  });

  @override
  List<Object> get props => [
        scrollController,
        textController,
        focusNode,
      ];
}
