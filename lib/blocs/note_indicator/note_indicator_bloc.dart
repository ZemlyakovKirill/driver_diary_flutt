import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'note_indicator_event.dart';
part 'note_indicator_state.dart';

class NoteIndicatorBloc extends Bloc<NoteIndicatorEvent, NoteIndicatorState> {
  NoteIndicatorBloc() : super(NoteIndicatorInitial()) {
    on<NoteTypeChangedEvent>((event, emit) {
      emit(NoteIndicatorChangedState(_noteIndicatorColor(event.index)));
    });
  }

  @override
  void onChange(Change<NoteIndicatorState> change) {
    super.onChange(change);
    log("NoteIndicatorBloc -> "+change.nextState.toString());
  }

  Color _noteIndicatorColor(int index){
    switch(index){
      case 0:
        return Colors.yellowAccent;
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.redAccent;
    }
    return Colors.transparent;
  }
}
