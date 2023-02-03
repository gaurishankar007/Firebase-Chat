part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final PageController pageController;
  final int pageIndex;

  const HomeLoadedState({
    required this.pageController,
    required this.pageIndex,
  });

  @override
  List<Object> get props => [
        pageController,
        pageIndex,
      ];
}
