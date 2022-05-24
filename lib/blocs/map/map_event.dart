part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MapInitialize extends MapEvent{

}

class GetLocationEvent extends MapEvent{}

class GetMarkersEvent extends MapEvent{
  final ThemeMode mode;
  GetMarkersEvent(this.mode);
}
class SetUserLocationEvent extends MapEvent{}

class MapTappedEvent extends MapEvent{
  final double lat;
  final double lon;

  MapTappedEvent(this.lat, this.lon);
}

class ConfirmMarkerEvent extends MapEvent{
  final bool isTruth;
  final int id;

  ConfirmMarkerEvent({required this.isTruth, required this.id});
}

class AddMarkerEvent extends MapEvent{
  final double lat;
  final double lon;
  final String name;
  final MarkerType type;

  AddMarkerEvent({required this.lat, required this.lon, required this.name, required this.type});
}

class SetMarkerTypeEvent extends MapEvent{
  final MarkerType markerType;
  final ThemeMode mode;

  SetMarkerTypeEvent({required this.mode,required this.markerType});
}

class AcceptedMarkerTappedEvent extends MapEvent{
  final double lat;
  final double lon;
  final MarkerType type;
  final String name;
  final String? additional;

  AcceptedMarkerTappedEvent({required this.lat, required this.lon, required this.type, required this.name, this.additional});
}

class RequestedMarkerTappedEvent extends MapEvent{
  final int id;
  final double lat;
  final double lon;
  final MarkerType type;
  final String name;
  final String? additional;

  RequestedMarkerTappedEvent({required this.id,required this.lat, required this.lon, required this.type, required this.name, this.additional});
}

class MapTypeChangedEvent extends MapEvent{
  final MapType mapType;

  MapTypeChangedEvent(this.mapType);


}

class TrafficChangedEvent extends MapEvent{
  final bool show;

  TrafficChangedEvent(this.show);
}

