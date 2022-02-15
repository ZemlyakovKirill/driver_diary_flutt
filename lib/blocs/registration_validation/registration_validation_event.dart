part of 'registration_validation_bloc.dart';

@immutable
abstract class RegistrationValidationEvent {}

class FirstStageValidationEvent extends RegistrationValidationEvent {
  final String username;
  final String password;
  final String passwordRepeat;

  FirstStageValidationEvent(
      {required this.username,
      required this.password,
      required this.passwordRepeat});
}

class SecondStageValidationEvent extends RegistrationValidationEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  SecondStageValidationEvent(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.phone});
}
