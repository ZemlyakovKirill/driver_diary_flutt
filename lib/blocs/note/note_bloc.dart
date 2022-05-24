import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/enums/cost_enum.dart';
import 'package:driver_diary/models/note_model.dart';
import 'package:driver_diary/views/note_filter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/http_utils.dart';

part 'note_event.dart';

part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  List<Note>? _uncompletedNotes;
  List<Note>? _completedNotes;
  List<Note>? _overduedNotes;
  Direction direction=Direction.asc;
  NoteSearchFilter searchFilter=NoteSearchFilter.description;

  NoteBloc() : super(NoteInitial()) {
    on<GetNotesUncompleted>(
        (event, emit) async => await _getUncompletedNotes(emit));
    on<GetNotesOverdued>((event, emit) async => await _getOverdueNotes(emit));
    on<GetNotesCompleted>(
        (event, emit) async => await _getCompletedNotes(emit));
    on<AddCostNoteEvent>(
        (event, emit) async => await _addCostNote(event, emit));
    on<AddNotCostNoteEvent>(
        (event, emit) async => await _addNotCostNote(event, emit));
    on<DeleteNoteEvent>((event, emit) async => await _deleteNote(event, emit));
    on<NoteDirectionChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setBool("note_search_direction",event.direction==Direction.asc?true:false);
      direction=event.direction;
      emit(NoteDirectionChangedState());
    });

    on<NoteSearchFilterChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setInt("note_search_filter",event.searchFilter.index);
      searchFilter=event.searchFilter;
      emit(NoteSearchFilterChangedState());
    });

    on<UnCompleteNoteEvent>((event, emit) async => await _uncompleteNote(event, emit));

    on<CompleteNoteEvent>((event, emit) async => await _completeNote(event, emit));

    SharedPreferences.getInstance().then((value){
      if(value.containsKey("note_search_direction")){
        add(NoteDirectionChangedEvent(
            value.getBool("note_search_direction")!?Direction.asc:Direction.desc
        ));
      }
      if(value.containsKey("note_search_filter")){
        add(NoteSearchFilterChangedEvent(
            NoteSearchFilter.values[value.getInt("note_search_filter")!]
        ));
      }
    });
  }

  @override
  void onChange(Change<NoteState> change) {
    super.onChange(change);
    log("NoteBloc ->" + change.nextState.toString());
  }

  Future<void> _getUncompletedNotes(Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.get(
          Uri.parse("https://themlyakov.ru:8080/user/note/uncompleted/all"
              "?sortBy=${searchFilter.asParameter()}"
              "&direction=${direction.asParameter()}"),
          headers: headers);
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _uncompletedNotes = (responseJson["response"] as List<dynamic>)
            .map((e) => Note.fromJson(e))
            .toList();
        emit(NotesUncompletedReceivedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _getCompletedNotes(Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.get(
          Uri.parse("https://themlyakov.ru:8080/user/note/completed/all"
              "?sortBy=${searchFilter.asParameter()}"
              "&direction=${direction.asParameter()}"),
          headers: headers);
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _completedNotes = (responseJson["response"] as List<dynamic>)
            .map((e) => Note.fromJson(e))
            .toList();
        emit(NotesCompletedReceivedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _getOverdueNotes(Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.get(
        Uri.parse("https://themlyakov.ru:8080/user/note/overdued/all"
            "?sortBy=${searchFilter.asParameter()}"
            "&direction=${direction.asParameter()}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _overduedNotes = (responseJson["response"] as List<dynamic>)
            .map((e) => Note.fromJson(e))
            .toList();
        emit(NotesOverduedReceivedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _deleteNote(
      DeleteNoteEvent event, Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.delete(
        Uri.parse(
            "https://themlyakov.ru:8080/user/note/delete/${event.note.noteID}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(NoteDeletedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _addNotCostNote(
      AddNotCostNoteEvent event, Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      if (event.note.description == null || event.note.description!.isEmpty) {
        emit(ValidationErrorState("Описание не может быть пустым"));
        return;
      }
      if (event.note.description!.length > 100) {
        emit(ValidationErrorState(
            "Длина описания должна быть не более 100 символов"));
        return;
      }
      final response = await http.post(
        Uri.parse("https://themlyakov.ru:8080/user/note/add"
            "?description=${event.note.description}"
            "&is_cost=false"
            "&is_completed=${event.note.isCompleted ? "true" : "false"}"
            "&end_date=${DateFormat("yyyy-MM-dd:HH:mm:ss").format(event.note.endDate)}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(NotCostNoteAddedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _completeNote(
      CompleteNoteEvent event, Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.post(
        Uri.parse(
            "https://themlyakov.ru:8080/user/note/complete/${event.note.noteID}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(NoteCompletedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _uncompleteNote(
      UnCompleteNoteEvent event, Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.post(
        Uri.parse(
            "https://themlyakov.ru:8080/user/note/uncomplete/${event.note.noteID}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
      as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(NoteUnCompletedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  Future<void> _addCostNote(
      AddCostNoteEvent event, Emitter<NoteState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      if (event.cost.costType == null) {
        emit(ValidationErrorState("Тип расхода не может быть пустым"));
        return;
      }
      if (event.cost.value == null) {
        emit(ValidationErrorState("Величина расхода не может быть пустым"));
        return;
      }
      if (event.cost.value! < 0) {
        emit(ValidationErrorState(
            "Величина расхода не может быть отрицательной"));
        return;
      }
      if (event.cost.vehicle == null) {
        emit(ValidationErrorState("Поле ТС не может быть пустым"));
        return;
      }
      final response = await http.post(
        Uri.parse("https://themlyakov.ru:8080/user/note/add"
            "?cost_type=${event.cost.costType!.getAsParameter()}"
            "&vehicle_id=${event.cost.vehicle!.id}"
            "&value=${event.cost.value!}"
            "&is_cost=true"
            "&is_completed=${event.cost.isCompleted ? "true" : "false"}"
            "&end_date=${DateFormat("yyyy-MM-dd:HH:mm:ss").format(event.cost.endDate)}"),
        headers: headers,
      );
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;
      if (response.statusCode == 200) {
        emit(CostNoteAddedState());
      } else {
        emit(NotesErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(NotesErrorState("Ошибка"));
    }
  }

  List<Note>? get uncompletedNotes => _uncompletedNotes;

  List<Note>? get completedNotes => _completedNotes;

  List<Note>? get overduedNotes => _overduedNotes;
}
