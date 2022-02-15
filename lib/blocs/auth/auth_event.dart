part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class RegistrateUserEvent extends AuthEvent {
  final String username;
  final String password;
  final String lastName;
  final String firstName;
  final String email;
  final String? phone;

  RegistrateUserEvent(
      {required this.username,
      required this.password,
      required this.lastName,
      required this.firstName,
      required this.email,
      this.phone});
}

class GetAndSaveTokenEvent extends AuthEvent{
  final String username;
  final String password;

  GetAndSaveTokenEvent({required this.username, required this.password});
}
class LoginViaGoogleEvent extends AuthEvent{
  final String url;

  LoginViaGoogleEvent(this.url);
}
class LoginViaVKEvent extends AuthEvent{
  final String url;

  LoginViaVKEvent(this.url);
}
class ErrorGoogleAuthEvent extends AuthEvent{
  final String errorMessage;

  ErrorGoogleAuthEvent(this.errorMessage);
}
class ErrorVKAuthEvent extends AuthEvent{
  final String errorMessage;

  ErrorVKAuthEvent(this.errorMessage);
}
class SaveTokenEvent extends AuthEvent {
  final String token;

  SaveTokenEvent(this.token);
}
