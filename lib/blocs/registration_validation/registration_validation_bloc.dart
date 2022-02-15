import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:meta/meta.dart';

part 'registration_validation_event.dart';
part 'registration_validation_state.dart';

class RegistrationValidationBloc
    extends Bloc<RegistrationValidationEvent, RegistrationValidationState> {
  RegistrationValidationBloc() : super(RegistrationValidationInitial()) {
    on<FirstStageValidationEvent>(
        (event, emit) => _firstValidation(event, emit));
    on<SecondStageValidationEvent>(
        (event, emit) => _secondValidation(event, emit));
  }
  @override
  void onChange(Change<RegistrationValidationState> change) {
    super.onChange(change);
    log('RegistrationValidationBloc -> '+change.nextState.toString());
  }
  void _firstValidation(FirstStageValidationEvent event,
      Emitter<RegistrationValidationState> emit) {
    if (event.username.isEmpty) {
      emit(FirstStageErrorValidationState(
          "Поле ввода никнейма не должно быть пустым"));
      return;
    } else if (RegExp(r'[^\w\d._-]+').hasMatch(event.username)) {
      emit(FirstStageErrorValidationState(
          "Поле ввода никнейма должно содержать латиницу, арабские цифры или \".-\""));
      return;
    }
    if (event.password.isEmpty) {
      emit(FirstStageErrorValidationState(
          "Поле ввода пароля не должно быть пустым"));
      return;
    } else if (RegExp(r'[^\w\d]+').hasMatch(event.password)) {
      emit(FirstStageErrorValidationState(
          "Поле ввода пароля должно содержать латиницу или арабские цифры"));
      return;
    }
    if (event.passwordRepeat.isEmpty) {
      emit(FirstStageErrorValidationState(
          "Поле ввода повтора пароля не должно быть пустым"));
      return;
    } else if (RegExp(r'[^\w\d]+').hasMatch(event.passwordRepeat)) {
      emit(FirstStageErrorValidationState(
          "Поле ввода повтора пароля должно содержать латиницу или арабские цифры"));
      return;
    }
    if (event.password != event.passwordRepeat) {
      emit(FirstStageErrorValidationState("Пароли не совпадают"));
      return;
    }
    emit(FirstStageValidationSuccessState(
        username: event.username, password: event.password));
  }

  void _secondValidation(SecondStageValidationEvent event,
      Emitter<RegistrationValidationState> emit) {
    if (event.lastName.isEmpty) {
      emit(SecondStageErrorValidationState(
          "Поле ввода фамилии не должно быть пустым"));
      return;
    } else if (!RegExp(r'^[A-ZА-Я][a-zа-я0-9]+$').hasMatch(event.lastName)) {
      emit(SecondStageErrorValidationState(
          "Поле ввода фамилии должно начинаться с заглавной буквы и содержать кириллицу, латиницу или арабские цифры"));
      return;
    }
    if (event.firstName.isEmpty) {
      emit(SecondStageErrorValidationState(
          "Поле ввода имени не должно быть пустым"));
      return;
    } else if (!RegExp(r'^[A-ZА-Я][a-zа-я]+$').hasMatch(event.firstName)) {
      emit(SecondStageErrorValidationState(
          "Поле ввода имени должно начинаться с заглавной буквы и содержать кириллицу или латиницу"));
      return;
    }
    if (event.email.isEmpty) {
      emit(SecondStageErrorValidationState(
          "Поле ввода электронной почты не должно быть пустым"));
      return;
    } else if (!RegExp(
            r'^([a-z0-9_]{2,40})(@)([a-z0-9._-]{2,7})(\.)([a-z]{2,5})$')
        .hasMatch(event.email)) {
      emit(SecondStageErrorValidationState(
          "Поле ввода электронной почты должно быть похожим на example@exmp.com"));
      return;
    }
    if (event.phone != null &&
        !RegExp(r'^(\+){0,1}[0-9()-]{10,20}$').hasMatch(event.phone!)) {
      emit(SecondStageErrorValidationState(
          "Поле ввода телефона должно содержать арабские символы или \"+,(,)\""));
      return;
    }
    emit(SecondStageValidationSuccessState());
  }
}
