part of 'stomp_bloc.dart';

@immutable
abstract class StompState {}

class StompInitial extends StompState{}

class StompClientInitialized extends StompState {}

class TokenStateReceived extends StompState{}

class ErrorUsernameCheckingState extends StompState implements ErrorFlag{
  final String errorMessage;

  ErrorUsernameCheckingState(this.errorMessage);
}

class ConnectedState extends StompState{}

class DisconnectedState extends StompState{}

class ErrorFrameState extends StompState implements ErrorFlag{
  final String errorMessage;

  ErrorFrameState(this.errorMessage);
}

class NotificationDataReceived extends StompState {
  final String body;

  NotificationDataReceived(this.body);
}
class ErrorTokenReceivingState extends StompState implements ErrorFlag{
  final String errorMessage;

  ErrorTokenReceivingState(this.errorMessage);
}

class NotificationDataReceivedState extends StompState {
  final String body;

  NotificationDataReceivedState(this.body);
}

class NewsDataReceivedState extends StompState {
  final String body;

  NewsDataReceivedState(this.body);
}

class NotesDataReceivedState extends StompState{
  final String body;

  NotesDataReceivedState(this.body);
}

class UserDataReceivedState extends StompState{
  final String body;

  UserDataReceivedState(this.body);
}

class CostsDataReceivedState extends StompState{
  final String body;

  CostsDataReceivedState(this.body);
}

class VehiclesDataReceivedState extends StompState{
  final String body;

  VehiclesDataReceivedState(this.body);
}

