part of 'note_indicator_bloc.dart';

@immutable
abstract class NoteIndicatorState {}

class NoteIndicatorInitial extends NoteIndicatorState {}

class NoteIndicatorChangedState extends NoteIndicatorState{
  final Color indicatorColor;

  NoteIndicatorChangedState(this.indicatorColor);
}
