part of 'login_validation_bloc.dart';

@immutable
abstract class LoginValidationState {}

class LoginValidationInitial extends LoginValidationState {}

class ValidationErrorState extends LoginValidationState implements ErrorFlag {
  final String errorMessage;

  ValidationErrorState(this.errorMessage);
}

class ValidationSuccessState extends LoginValidationState{}
