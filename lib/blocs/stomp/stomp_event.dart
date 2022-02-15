part of 'stomp_bloc.dart';

@immutable
abstract class StompEvent {}

class InitializeStompClientEvent extends StompEvent {}

class CloseConnectionToStompEvent extends StompEvent {}

class NotificationDataReceivedEvent extends StompEvent {
  final String body;

  NotificationDataReceivedEvent(this.body);
}

class TokenStateReceivedEvent extends StompEvent{
  final int status;

  TokenStateReceivedEvent(this.status);
}

class NewsDataReceivedEvent extends StompEvent {
  final String body;

  NewsDataReceivedEvent(this.body);
}

class NotesDataReceivedEvent extends StompEvent{
  final String body;

  NotesDataReceivedEvent(this.body);
}

class UserDataReceivedEvent extends StompEvent{
  final String body;

  UserDataReceivedEvent(this.body);
}

class CostsDataReceivedEvent extends StompEvent{
  final String body;

  CostsDataReceivedEvent(this.body);
}

class VehiclesDataReceivedEvent extends StompEvent{
  final String body;

  VehiclesDataReceivedEvent(this.body);
}