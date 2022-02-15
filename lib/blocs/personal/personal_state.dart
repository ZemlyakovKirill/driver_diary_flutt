part of 'personal_bloc.dart';

@immutable
abstract class PersonalState {}

class PersonalInitial extends PersonalState {}

class PersonalDataReceivedState extends PersonalState{}

class PersonalErrorState extends PersonalState{
  final String errorMessage;

  PersonalErrorState(this.errorMessage);
}
