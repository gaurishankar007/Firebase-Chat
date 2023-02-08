part of 'chat_list_bloc.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

class ChatListLoadingState extends ChatListState {}

class ChatListLoadedState extends ChatListState {
  final List<DocumentSnapshot<ChatModel>> chatModels;

  const ChatListLoadedState({required this.chatModels});

  @override
  List<Object> get props => [chatModels];
}
