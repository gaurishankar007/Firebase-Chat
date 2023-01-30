import 'package:equatable/equatable.dart';

abstract class DataState<T> extends Equatable {
  final T? data;
  final String? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({required T data}) : super(data: data);

  @override
  List<Object?> get props => [data];
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({required String error}) : super(error: error);

  @override
  List<Object?> get props => [error];
}

class ServerTimeOut<T> extends DataState<T> {
  const ServerTimeOut();

  @override
  List<Object?> get props => [];
}
