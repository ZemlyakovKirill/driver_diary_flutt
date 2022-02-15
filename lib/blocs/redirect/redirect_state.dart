part of 'redirect_bloc.dart';

@immutable
abstract class RedirectState {}

class RedirectInitial extends RedirectState {}

class RedirectToLoginState extends RedirectState{}

class RedirectToRegistrationFirstState extends RedirectState{}

class RedirectToRegistrationSecondState extends RedirectState{
  final String username;
  final String password;

  RedirectToRegistrationSecondState({required this.username, required this.password});
}

class RedirectToGoogleState extends RedirectState{}

class RedirectToVKState extends RedirectState{}
