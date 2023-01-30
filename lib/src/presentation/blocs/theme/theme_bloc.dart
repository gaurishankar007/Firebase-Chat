import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/local/local_data.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: LocalData.getThemeMode())) {
    on<ThemeEvent>(_themeEvent);
  }

  _themeEvent(ThemeEvent event, emit) {
    LocalData.addThemeMode(themeMode: event.themeMode);

    emit(ThemeState(themeMode: event.themeMode));
  }
}
