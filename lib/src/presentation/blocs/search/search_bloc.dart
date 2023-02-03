import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/data/remote/repositories/user_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TextEditingController searchController = TextEditingController();
  late List<UserDataModel> userDataModels;
  bool searching = false;

  SearchBloc() : super(SearchLoadingState()) {
    on<SearchLoadedEvent>(_searchLoadedEvent);
    on<SearchToggleEvent>(_searchToggleEvent);
  }

  _searchLoadedEvent(SearchLoadedEvent event, emit) async {
    emit(SearchLoadingState());

    final userData = await FirebaseUserRepoImpl().loadUsers();
    userDataModels = userData.data!;

    emit(SearchResultState(
      searchController: searchController,
      userDataModels: userDataModels,
      searching: searching,
    ));
  }

  _searchToggleEvent(SearchToggleEvent event, emit) {
    emit(SearchResultState(
      searchController: searchController,
      userDataModels: userDataModels,
      searching: event.searching,
    ));
  }
}
