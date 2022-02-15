part of 'redirect_bloc.dart';

@immutable
abstract class RedirectEvent {}

class RedirectToLoginPageEvent extends RedirectEvent{}
class RedirectToFirstRegistratePageEvent extends RedirectEvent{}
class RedirectToSecondRegistratePageEvent extends RedirectEvent{
  final String username;
  final String password;

  RedirectToSecondRegistratePageEvent({required this.username, required this.password});
}
class RedirectToGooglePageEvent extends RedirectEvent {}
class RedirectToVKPageEvent extends RedirectEvent {}
