part of 'redirect_bloc.dart';

@immutable
abstract class RedirectState {}

class RedirectInitial extends RedirectState {}

class RedirectToLoginState extends RedirectState{}

class RedirectToRegistrationFirstState extends RedirectState{}

class RedirectToNoConnectionPageState extends RedirectState{}

class RedirectToHomePageState extends RedirectState{}

class RedirectToEditProfilePageState extends RedirectState{
  final User user;

  RedirectToEditProfilePageState(this.user);
}
class RedirectToErrorLoginState extends RedirectState{}

class RedirectToRegistrationSecondState extends RedirectState{
  final String username;
  final String password;

  RedirectToRegistrationSecondState({required this.username, required this.password});
}

class RedirectToGoogleState extends RedirectState{}

class RedirectToVKState extends RedirectState{}
