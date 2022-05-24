part of 'personal_bloc.dart';

@immutable
abstract class PersonalEvent {}

class GetPersonalDataEvent extends PersonalEvent{}

class EditPersonalDataEvent extends PersonalEvent{
  final User user;

  EditPersonalDataEvent(this.user);
}
