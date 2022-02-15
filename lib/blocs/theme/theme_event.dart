part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent{
  ThemeMode mode;

  ChangeThemeEvent(this.mode);
}
