part of 'note_bloc.dart';

@immutable
abstract class NoteState {}

class NoteInitial extends NoteState {}

class NotesOverduedReceivedState extends NoteState {}

class NotesCompletedReceivedState extends NoteState {}

class NotesUncompletedReceivedState extends NoteState {}

class NotesOverduedErrorState extends NoteState {
  final String errorMessage;

  NotesOverduedErrorState(this.errorMessage);
}
class NotesCompletedErrorState extends NoteState {
  final String errorMessage;

  NotesCompletedErrorState(this.errorMessage);
}class NotesUncompletedErrorState extends NoteState {
  final String errorMessage;

  NotesUncompletedErrorState(this.errorMessage);
}
