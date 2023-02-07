import 'package:firebase_chat/src/data/remote/models/user_model.dart';
import 'package:firebase_chat/src/data/remote/repositories/user_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constant.dart';
import '../../../core/resources/data_state.dart';
import '../../widgets/messages/message.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TextEditingController searchController = TextEditingController();
  List<UserDataModel> userDataModels = [];
  bool searching = false;

  final BuildContext context;

  SearchBloc({required this.context}) : super(SearchLoadingState()) {
    on<SearchLoadedEvent>(_searchLoadedEvent);
    on<SearchToggleEvent>(_searchToggleEvent);
    on<SearchingEvent>(_searching);
  }

  _searchLoadedEvent(SearchLoadedEvent event, emit) async {
    emit(SearchLoadingState());

    final dataState = await FirebaseUserRepoImpl().loadUsers();
    if (dataState is DataFailed && context.mounted) {
      MessageScreen.message().show(
        context: context,
        message: "Error occurred while loading users.",
        type: MessageType.error,
      );
    } else if (dataState is ServerTimeOut && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No Internet.",
            style: smallBoldText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (dataState is DataSuccess) {
      userDataModels = dataState.data!;
    }

    emit(SearchResultState(
      searchController: searchController,
      userDataModels: userDataModels,
      searching: searching,
    ));
  }

  _searchToggleEvent(SearchToggleEvent event, emit) async {
    if (!event.searching) {
      searchController.clear();
    }
    searching = event.searching;

    final dataState = await FirebaseUserRepoImpl().loadUsers();
    if (dataState is DataFailed && context.mounted) {
      MessageScreen.message().show(
        context: context,
        message: "Error occurred while loading users.",
        type: MessageType.error,
      );
    } else if (dataState is ServerTimeOut && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No Internet.",
            style: smallBoldText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (dataState is DataSuccess) {
      userDataModels = dataState.data!;
    }

    emit(SearchResultState(
      searchController: searchController,
      userDataModels: userDataModels,
      searching: searching,
    ));
  }

  _searching(SearchingEvent event, emit) async {
    if (event.name.isEmpty) return;

    final dataState =
        await FirebaseUserRepoImpl().searchUsers(name: event.name);
    if (dataState is DataSuccess) {
      print("a");
      userDataModels = dataState.data!;
    } else if (dataState is DataFailed) {
      print(dataState.error);
    }

    emit(SearchResultState(
      searchController: searchController,
      userDataModels: userDataModels,
      searching: searching,
    ));
  }
}
