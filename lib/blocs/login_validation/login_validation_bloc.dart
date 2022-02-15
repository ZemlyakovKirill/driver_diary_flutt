import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:flutter/cupertino.dart';

part 'login_validation_state.dart';
part 'login_validation_event.dart';

class LoginValidationBloc extends Bloc<LoginValidationEvent, LoginValidationState> {
  LoginValidationBloc() : super(LoginValidationInitial()) {
    on<ValidateEvent>((event, emit)=>_isValid(event, emit));
  }

  void _isValid(ValidateEvent event,Emitter<LoginValidationState> emit){
    if (event.username.isEmpty) {
      emit(ValidationErrorState("Поле ввода никнейма не может быть пустым"));
      return;
    } else if (RegExp(r'[^\w\d._-]+').hasMatch(event.username)) {
      emit(ValidationErrorState("Поле ввода никнейма должно содержать только символы латицины, арабские символы и \".-_\""));
      return;
    }
    if (event.password.isEmpty) {
      emit(ValidationErrorState("Поле ввода пароля не может быть пустым"));
      return;
    } else if (RegExp(r'[^\w\d]+').hasMatch(event.password)) {
      emit(ValidationErrorState("Поле ввода пароля должно содержать только символы латицины, арабские символы и \".-_\""));
      return;
    }
    emit(ValidationSuccessState());
  }

  @override
  void onChange(Change<LoginValidationState> change) {
    super.onChange(change);
    log('LoginValidationBloc -> '+change.nextState.toString());
  }
}
