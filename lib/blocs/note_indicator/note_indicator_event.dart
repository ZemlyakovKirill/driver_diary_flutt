part of 'note_indicator_bloc.dart';

@immutable
abstract class NoteIndicatorEvent {}

class NoteTypeChangedEvent extends NoteIndicatorEvent{
  final int index;

  NoteTypeChangedEvent(this.index);
}