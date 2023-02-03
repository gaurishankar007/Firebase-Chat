part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {}

class SearchResultState extends SearchState {
  final TextEditingController searchController;
  final List<UserDataModel> userDataModels;
  final bool searching;

  const SearchResultState({
    required this.searchController,
    required this.userDataModels,
    required this.searching,
  });

  @override
  List<Object> get props => [
        searchController,
        userDataModels,
        searching,
      ];
}
