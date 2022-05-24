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
class RedirectToErrorLoginPageEvent extends RedirectEvent{}
class RedirectToEditProfilePageEvent extends RedirectEvent{
  final User user;

  RedirectToEditProfilePageEvent(this.user);
}
class RedirectToEditVehiclePageEvent extends RedirectEvent{}
class RedirectToEdit extends RedirectEvent{}
class RedirectToHomePageEvent extends RedirectEvent{}
class RedirectToNoConnectionPageEvent extends RedirectEvent{}
class RedirectToGooglePageEvent extends RedirectEvent {}
class RedirectToVKPageEvent extends RedirectEvent {}
