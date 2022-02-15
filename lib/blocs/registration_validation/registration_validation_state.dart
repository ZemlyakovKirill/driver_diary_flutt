part of 'registration_validation_bloc.dart';

@immutable
abstract class RegistrationValidationState {}

class RegistrationValidationInitial extends RegistrationValidationState {}

class FirstStageErrorValidationState extends RegistrationValidationState implements ErrorFlag{
  final String errorMessage;

  FirstStageErrorValidationState(this.errorMessage);
}

class FirstStageValidationSuccessState extends RegistrationValidationState{
  final String username;
  final String password;

  FirstStageValidationSuccessState({required this.username, required this.password});
}

class SecondStageErrorValidationState extends RegistrationValidationState implements ErrorFlag{
  final String errorMessage;

  SecondStageErrorValidationState(this.errorMessage);
}

class SecondStageValidationSuccessState extends RegistrationValidationState{}
