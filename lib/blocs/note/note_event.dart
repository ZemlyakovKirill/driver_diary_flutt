part of 'note_bloc.dart';

@immutable
abstract class NoteEvent {}

class GetNotesUncompleted extends NoteEvent {}

class GetNotesCompleted extends NoteEvent {}

class GetNotesOverdued extends NoteEvent {}
