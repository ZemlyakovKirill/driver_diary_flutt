import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/note_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  List<Note>? _uncompletedNotes;
  List<Note>? _completedNotes;
  List<Note>? _overduedNotes;


  NoteBloc() : super(NoteInitial()) {
    on<GetNotesUncompleted>((event, emit) async=> await _getUncompletedNotes(emit));
    on<GetNotesOverdued>((event, emit) async=> await _getOverdueNotes(emit));
    on<GetNotesCompleted>((event, emit) async=> await _getCompletedNotes(emit));
  }

  List<Note>? get uncompletedNotes => _uncompletedNotes;


  @override
  void onChange(Change<NoteState> change) {
    super.onChange(change);
    log("NoteBloc ->"+change.nextState.toString());
  }

  Future<void>  _getUncompletedNotes(Emitter<NoteState> emit)async{
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/note/uncompleted/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        _uncompletedNotes=(responseJson["response"] as List<dynamic>).map((e) => Note.fromJson(e)).toList();
        emit(NotesUncompletedReceivedState());
      }else{
        emit(NotesUncompletedErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(NotesUncompletedErrorState("Ошибка"));
    }
  }
  Future<void>  _getCompletedNotes(Emitter<NoteState> emit)async{    final instance = await SharedPreferences.getInstance();
  String token=instance.getString("token")!;
  Map<String,String> headers=Map.identity();
  headers.putIfAbsent("Authorization", () => "Bearer "+token);
  try{
    final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/note/completed/all"),
        headers: headers, encoding: Encoding.getByName("UTF-8"));
    final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

    if(response.statusCode==200){
      _completedNotes=(responseJson["response"] as List<dynamic>).map((e) => Note.fromJson(e)).toList();
      emit(NotesCompletedReceivedState());
    }else{
      emit(NotesCompletedErrorState(responseJson["response"] as String));
    }
  }on Exception{
    emit(NotesCompletedErrorState("Ошибка"));
  }
  }
  Future<void>  _getOverdueNotes(Emitter<NoteState> emit)async{
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/note/overdued/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        _overduedNotes=(responseJson["response"] as List<dynamic>).map((e) => Note.fromJson(e)).toList();
        emit(NotesOverduedReceivedState());
      }else{
        emit(NotesOverduedErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(NotesOverduedErrorState("Ошибка"));
    }
  }

  List<Note>? get completedNotes => _completedNotes;

  List<Note>? get overduedNotes => _overduedNotes;
}
