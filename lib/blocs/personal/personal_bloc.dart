import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'personal_event.dart';
part 'personal_state.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  User? user;

  PersonalBloc() : super(PersonalInitial()) {
    on<GetPersonalDataEvent>((event, emit)async => await _getPersonalData(emit));
    on<EditPersonalDataEvent>((event,emit)async=>await _editPersonalData(event, emit));
  }


  @override
  void onChange(Change<PersonalState> change) {
    super.onChange(change);
    log("PersonalBloc -> "+change.nextState.toString());
  }

  Future<void> _getPersonalData(Emitter<PersonalState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.get(Uri.parse("https://themlyakov.ru:8080/user/personal"),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        user=User.fromJson(responseJson["response"]);
        emit(PersonalDataReceivedState());
      }else{
        emit(PersonalErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(PersonalErrorState("Ошибка"));
    }

  }

  Future<void> _editPersonalData(EditPersonalDataEvent event,Emitter<PersonalState> emit)async{
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      if (event.user.username.isEmpty) {
        emit(ValidationErrorState("Поле ввода никнейма не может быть пустым"));
        return;
      } else if (RegExp(r'[^\w\d._-]+').hasMatch(event.user.username)) {
        emit(ValidationErrorState("Поле ввода никнейма должно содержать только символы латицины, арабские символы и \".-_\""));
        return;
      }
      if (event.user.lname.isEmpty) {
        emit(ValidationErrorState(
            "Поле ввода фамилии не должно быть пустым"));
        return;
      } else if (!RegExp(r'^[A-ZА-Я][a-zа-я0-9]+$').hasMatch(event.user.lname)) {
        emit(ValidationErrorState(
            "Поле ввода фамилии должно начинаться с заглавной буквы и содержать кириллицу, латиницу или арабские цифры"));
        return;
      }
      if (event.user.fname.isEmpty) {
        emit(ValidationErrorState(
            "Поле ввода имени не должно быть пустым"));
        return;
      } else if (!RegExp(r'^[A-ZА-Я][a-zа-я0-9]+$').hasMatch(event.user.fname)) {
        emit(ValidationErrorState(
            "Поле ввода имени должно начинаться с заглавной буквы и содержать кириллицу, латиницу или арабские цифры"));
        return;
      }
      if (event.user.email.isEmpty) {
        emit(ValidationErrorState(
            "Поле ввода электронной почты не должно быть пустым"));
        return;
      } else if (!RegExp(
          r'^([a-z0-9_]{2,40})(@)([a-z0-9._-]{2,7})(\.)([a-z]{2,5})$')
          .hasMatch(event.user.email)) {
        emit(ValidationErrorState(
            "Поле ввода электронной почты должно быть похожим на example@exmp.com"));
        return;
      }
      final response = await http.put(Uri.parse("https://themlyakov.ru:8080/user/personal/edit"
          "?email=${event.user.email}"
          "&fname=${event.user.fname}"
          "&lname=${event.user.lname}"
          "&phone=${event.user.phone}"
          "&username=${event.user.username}"
      ),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        emit(PersonalEditedState());
        await _getPersonalData(emit);
        return;
      }else{
        log(responseJson.toString());
        emit(PersonalErrorState(responseJson["response"] as String));
        return;
      }
    }on Exception{
      emit(PersonalErrorState("Ошибка"));
      return;
    }
  }
}
