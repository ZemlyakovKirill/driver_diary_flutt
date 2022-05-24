import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeMode _mode=ThemeMode.dark;

  ThemeBloc() : super(ThemeInitial()) {
    on<ChangeThemeEvent>((event, emit) {
      _mode=event.mode;
      emit(ThemeChangedState());
    });
  }

  ThemeMode get mode => _mode;
}
