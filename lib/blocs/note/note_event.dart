part of 'note_bloc.dart';

@immutable
abstract class NoteEvent {}

class GetNotesUncompleted extends NoteEvent {}

class GetNotesCompleted extends NoteEvent {}

class GetNotesOverdued extends NoteEvent {}

class DeleteNoteEvent extends NoteEvent{
  final Note note;

  DeleteNoteEvent(this.note);
}

class NoteSearchFilterChangedEvent extends NoteEvent{
  final NoteSearchFilter searchFilter;

  NoteSearchFilterChangedEvent(this.searchFilter);
}

class NoteDirectionChangedEvent extends NoteEvent{
  final Direction direction;

  NoteDirectionChangedEvent(this.direction);
}

class CompleteNoteEvent extends NoteEvent{
  final Note note;

  CompleteNoteEvent(this.note);
}

class UnCompleteNoteEvent extends NoteEvent{
  final Note note;

  UnCompleteNoteEvent(this.note);
}

class AddCostNoteEvent extends NoteEvent{
    final Note cost;

    AddCostNoteEvent(this.cost);
}

class AddNotCostNoteEvent extends NoteEvent{
  final Note note;

  AddNotCostNoteEvent(this.note);
}
