import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageController pageController = PageController();
  int pageIndex = 0;
  
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadedEvent>(_homeLoaded);
    on<NewPageEvent>(_newPage);
  }

  _homeLoaded(HomeLoadedEvent event, emit) async {
    emit(HomeLoadingState());

    await Future.delayed(Duration(seconds: 5));

    emit(HomeLoadedState(
      pageController: pageController,
      pageIndex: pageIndex,
    ));
  }

  _newPage(NewPageEvent event, emit) {
    pageController.jumpToPage(event.pageIndex);
    pageIndex = event.pageIndex;
    emit(HomeLoadedState(
      pageController: pageController,
      pageIndex: pageIndex,
    ));
  }
}
