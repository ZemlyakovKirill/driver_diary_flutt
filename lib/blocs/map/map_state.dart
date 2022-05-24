part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapDataReceived extends MapState{}

class MapTappedState extends MapState{
  final double lat;
  final double lon;

  MapTappedState(this.lat, this.lon);
}

class UserLocationReceivedState extends MapState{
  double lon;
  double lat;

  UserLocationReceivedState({required this.lon, required this.lat});
}

class MarkersReceivedState extends MapState{
  Set<Marker> acceptedMarkers;
  Set<Marker> requestedMarkers;
  MarkersReceivedState({required this.acceptedMarkers, required this.requestedMarkers});
}

class ErrorPositionState extends MapState implements ErrorFlag{
  final String errorMessage;

  ErrorPositionState(this.errorMessage);
}

class MarkerTappedState extends MapState{
  final double lat;
  final double lon;
  final MarkerType type;
  final String name;
  final String? additional;

  MarkerTappedState({required this.lat, required this.lon, required this.type, required this.name, this.additional});
}

class RequestedMarkerTappedState extends MarkerTappedState{
  final int id;
  final double lat;
  final double lon;
  final MarkerType type;
  final String name;
  final String? additional;

  RequestedMarkerTappedState({required this.id,required this.lat, required this.lon, required this.type, required this.name, this.additional})
      : super(lat:lat,lon: lon,name: name,type: type,additional: additional);
}

class MarkerAddedState extends MapState{

}

class MapTypeChangedState extends MapState{

}

class DirectionChangedState extends MapState{

}

class TrafficChangedState extends MapState{

}

class MarkerConfirmedState extends MapState{}

class ErrorMarkerState extends MapState{
  final String errorMessage;

  ErrorMarkerState(this.errorMessage);
}
