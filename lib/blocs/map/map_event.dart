part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MapInitialize extends MapEvent{}

class GetLocationEvent extends MapEvent{}

class GetMarkersEvent extends MapEvent{}

class SetUserLocationEvent extends MapEvent{}

class SetMarkerTypeEvent extends MapEvent{
  MarkerType markerType;

  SetMarkerTypeEvent({required this.markerType});
}

class MarkerTappedEvent extends MapEvent{
  final double lat;
  final double lon;
  final String type;
  final String name;
  final String? additional;

  MarkerTappedEvent({required this.lat, required this.lon, required this.type, required this.name, this.additional});
}

class AddMarkerEvent extends MapEvent{
  final double lat;
  final double lon;

  AddMarkerEvent({required this.lat, required this.lon});
}

