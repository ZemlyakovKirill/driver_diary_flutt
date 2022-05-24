part of 'note_bloc.dart';

@immutable
abstract class NoteState {}

class NoteInitial extends NoteState {}

class NotesOverduedReceivedState extends NoteState {}

class NotesCompletedReceivedState extends NoteState {}

class NotesUncompletedReceivedState extends NoteState {}

class NotesErrorState extends NoteState {
  final String errorMessage;

  NotesErrorState(this.errorMessage);
}

class NoteDeletedState extends NoteState {}

class NoteDirectionChangedState extends NoteState {}

class NoteSearchFilterChangedState extends NoteState {}

class NoteCompletedState extends NoteState {}

class NoteUnCompletedState extends NoteState {}

class ValidationErrorState extends NoteState {
  final String errorMessage;

  ValidationErrorState(this.errorMessage);
}

class CostNoteAddedState extends NoteState {}

class NotCostNoteAddedState extends NoteState {}
