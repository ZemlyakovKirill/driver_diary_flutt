part of 'personal_bloc.dart';

@immutable
abstract class PersonalState {}

class PersonalInitial extends PersonalState {}

class PersonalDataReceivedState extends PersonalState{}

class  ValidationErrorState extends PersonalState{
  final String errorMessage;

  ValidationErrorState(this.errorMessage);
}

class PersonalErrorState extends PersonalState{
  final String errorMessage;

  PersonalErrorState(this.errorMessage);
}

class PersonalEditedState extends PersonalState{}
