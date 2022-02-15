part of 'login_validation_bloc.dart';


@immutable
abstract class LoginValidationEvent {}

class ValidateEvent extends LoginValidationEvent{
  final String username;
  final String password;

  ValidateEvent({required this.username, required this.password});
}
