import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()){
    on<CheckAuthEvent>((event, emit) async => await _checkTokenValid(emit));
    on<LogoutEvent>((event,emit) async{
      SharedPreferences instance=await SharedPreferences.getInstance();
      instance.remove("token");
      emit(UnAuthorizedState());
    });


    on<GetAndSaveTokenEvent>((event,emit) async => await _getToken(event, emit));

    on<RegistrateUserEvent>((event,emit)async =>await _registrateUser(event, emit));

    on<SaveTokenEvent>((event,emit)async{
      SharedPreferences instance=await SharedPreferences.getInstance();
      instance.setString("token", event.token);
      emit(TokenSavedState());
    });

    on<ErrorGoogleAuthEvent>((event,emit){
      add(LogoutEvent());
      emit(ErrorGoogleAuthState(event.errorMessage));
    });

    on<ErrorVKAuthEvent>((event,emit){
      add(LogoutEvent());
      emit(ErrorVKAuthState(event.errorMessage));
    });
    on<LoginViaGoogleEvent>((event, emit) async {
      try{
        final response=await http.post(Uri.parse(event.url),encoding: Encoding.getByName("UTF-8"));
        if(response.statusCode==200){
          final responseToken=json.decode(utf8.decode(response.body.runes.toList()))['response'];
          add(SaveTokenEvent(responseToken));
          add(CheckAuthEvent());
        }else{
          final responseError=json.decode(utf8.decode(response.body.runes.toList()))['response'];
          emit(ErrorGoogleAuthState(responseError));
        }
      }on Exception{
        emit(ErrorGoogleAuthState("Ошибка"));
      }
    });

    on<LoginViaVKEvent>((event, emit) async{
      try{
        final response=await http.post(Uri.parse(event.url),encoding: Encoding.getByName("UTF-8"));
        if(response.statusCode==200){
          final responseToken=json.decode(utf8.decode(response.body.runes.toList()))['response'];
          add(SaveTokenEvent(responseToken));
          add(CheckAuthEvent());
        }else{
          final responseError=json.decode(utf8.decode(response.body.runes.toList()))['response'];
          emit(ErrorVKAuthState(responseError));
        }
      }on Exception{
        emit(ErrorVKAuthState("Ошибка"));
    }
    });
  }


  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    log('AuthBloc -> '+change.nextState.toString());
  }

  Future<void> _checkTokenValid(Emitter<AuthState> emit) async {

    SharedPreferences instance=await SharedPreferences.getInstance();
    if(instance.containsKey("token")){
      String token=instance.getString("token")!;
      Map<String, String> headers = Map.identity();
      headers.putIfAbsent("Authorization", () => "Bearer " + token);
      try {
        final response = await http
            .post(Uri.parse("https://themlyakov.ru:8080/user/testtoken"),
            headers: headers)
            .timeout(Duration(seconds: 10));
        if (response.statusCode == 200) {
          emit(AuthorizedState(token: token));
          return;
        }else if(response.statusCode == 403){
          emit(UnAuthorizedState());
          return;
        }
      }on Exception {
        emit(ErrorAuthorizingState(errorMessage: "Ошибка"));
        return;
      }
    }
    emit(UnAuthorizedState());
  }
  Future<void> _registrateUser(
         RegistrateUserEvent event,
         Emitter<AuthState> emit
      ) async {
    final response = await http.post(
            Uri.parse('https://themlyakov.ru:8080/auth/registrate' +
                '?username=${event.username}' +
                '&password=${event.password}' +
                '&lname=${event.lastName}' +
                '&fname=${event.firstName}' +
                '&email=${event.email}' +
                '&telnum='+(event.phone ?? '')),
            encoding: Encoding.getByName("UTF-8"));
    if (response.statusCode == 201) {
     emit(UserCreatedState());
    } else {
      String errorMessage=json.decode(utf8.decode(response.body.runes.toList()))['response'];
      emit(ErrorCreatingState(errorMessage));
    }
  }
  Future<void> _getToken(GetAndSaveTokenEvent event,Emitter<AuthState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =await  http.post(
          Uri.parse(
              "https://themlyakov.ru:8080/auth/login?username=${event.username}&password=${event.password}"),
          encoding: Encoding.getByName('utf-8'));
    final responseString =
    json.decode(utf8.decode(response.body.runes.toList()))['response'];
    if (response.statusCode == 200) {
      add(SaveTokenEvent(responseString));
      add(CheckAuthEvent());
      emit(TokenReceivedState());
    } else {
      emit(state);
    }
  }
}
