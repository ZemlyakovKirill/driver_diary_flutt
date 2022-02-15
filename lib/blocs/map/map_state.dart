part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapDataReceived extends MapState{}

class UserLocationReceivedState extends MapState{
  double lon;
  double lat;

  UserLocationReceivedState({required this.lon, required this.lat});
}

class MarkersReceivedState extends MapState{
  Set<Marker> markers;

  MarkersReceivedState(this.markers);
}

class ErrorPositionState extends MapState implements ErrorFlag{
  final String errorMessage;

  ErrorPositionState(this.errorMessage);
}

class MarkerTappedState extends MapState{
  final double lat;
  final double lon;
  final String type;
  final String name;
  final String? additional;

  MarkerTappedState({required this.lat, required this.lon, required this.type, required this.name, this.additional});
}

class ErrorMarkerState extends MapState{
  final String errorMessage;

  ErrorMarkerState(this.errorMessage);
}
