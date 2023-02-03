part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {}

class NewPageEvent extends HomeEvent {
  final int pageIndex;
  const NewPageEvent({
    required this.pageIndex,
  });

  @override
  List<Object> get props => [
        pageIndex,
      ];
}
