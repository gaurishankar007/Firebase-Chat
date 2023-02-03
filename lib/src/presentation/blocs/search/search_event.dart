part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchLoadedEvent extends SearchEvent {}

class SearchToggleEvent extends SearchEvent {
  final bool searching;

  const SearchToggleEvent({required this.searching});
}
