part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  final ThemeMode themeMode;
  
  const ThemeEvent({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
