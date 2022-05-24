import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:driver_diary/enums/marker_enum.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  double? lon;
  double? lat;
  MarkerType searchType = MarkerType.gas;
  Set<Marker>? markers;
  MapType mapType=MapType.normal;
  bool showTraffic=false;

  MapBloc() : super(MapInitial()) {
    on<GetLocationEvent>((event, emit) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lon = position.longitude;
      lat = position.latitude;
      emit(MapDataReceived());
    });
    on<MapInitialize>((event, emit) => emit(MapInitial()));
    on<SetUserLocationEvent>((event, emit) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lon = position.longitude;
      lat = position.latitude;
      emit(UserLocationReceivedState(lon: lon!, lat: lat!));
    });
    on<MapTypeChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setInt("map_type",event.mapType.index);
      mapType=event.mapType;
      emit(MapTypeChangedState());
    });

    on<TrafficChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setBool("show_traffic",event.show);
      showTraffic=event.show;
      emit(TrafficChangedState());
    });
    on<GetMarkersEvent>((event, emit) async => await _getMarkers(event, emit));
    on<MapTappedEvent>((event, emit) => emit(MapTappedState(event.lat,event.lon)));
    on<AddMarkerEvent>((event, emit) async => await _addMarker(event, emit));
    on<ConfirmMarkerEvent>((event,emit)async => await _confirmMarker(event, emit));
    on<AcceptedMarkerTappedEvent>((event, emit) {
      emit(MarkerTappedState(
          lat: event.lat,
          lon: event.lon,
          type: event.type,
          name: event.name,
          additional: event.additional));
    });
    on<RequestedMarkerTappedEvent>((event, emit) {
      emit(RequestedMarkerTappedState(
          id: event.id,
          lat: event.lat,
          lon: event.lon,
          type: event.type,
          name: event.name,
          additional: event.additional));
    });

    on<SetMarkerTypeEvent>((event, emit) {
      searchType = event.markerType;
      add(GetMarkersEvent(event.mode));
    });

    SharedPreferences.getInstance().then((value) {
      if(value.containsKey("map_type")){
        add(MapTypeChangedEvent(MapType.values[value.getInt("map_type")!]));
      }
      if(value.containsKey("show_traffic")){
        add(TrafficChangedEvent(value.getBool("show_traffic")!));
      }
    });
  }

  @override
  void onChange(Change<MapState> change) {
    super.onChange(change);
    log("MapBloc -> " + change.nextState.toString());
  }

  Future<void> _getMarkers(GetMarkersEvent event, Emitter<MapState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.get(
          Uri.parse(
              "https://themlyakov.ru:8080/user/mark/get?lat=$lat&lon=$lon&type=${searchType.getAsParameter()}"),
          headers: headers);
      if (response.statusCode == 200) {
        final responseAccepted =
            json.decode(utf8.decode(response.body.codeUnits))['response']['accepted']
                as List<dynamic>;
        final responseRequested =
        json.decode(utf8.decode(response.body.codeUnits))['response']['requested']
        as List<dynamic>;
        final acceptedIcon = await getAcceptedMarkerIcon(event.mode,searchType);
        final requestIcon=await getRequestedMarkerIcon(event.mode);
        emit(MarkersReceivedState(
            acceptedMarkers: responseAccepted
                .map((e) => Marker(
                markerId: MarkerId(e["lat"].toString() + e["lon"]!.toString()),
                position: LatLng(e["lat"], e["lon"]),
                icon: acceptedIcon,
                onTap: () {
                  add(AcceptedMarkerTappedEvent(
                    lat: e["lat"],
                    lon: e["lon"],
                    name: e["name"],
                    type: getType(e["type"])??MarkerType.gas,
                  ));
                }))
                .toSet(),
            requestedMarkers: responseRequested
                .map((e) => Marker(
                markerId: MarkerId(e["lat"].toString() + e["lon"]!.toString()),
                position: LatLng(e["lat"], e["lon"]),
                icon:  requestIcon,
                onTap: () {
                  add(RequestedMarkerTappedEvent(
                    id: e["id"],
                    lat: e["lat"],
                    lon: e["lon"],
                    name: e["name"],
                    type: getType(e["type"])??MarkerType.gas,
                  ));
                }))
                .toSet(),));
        emit(MapDataReceived());
      } else {
        emit(ErrorMarkerState(
            json.decode(utf8.decode(response.body.codeUnits))['response']));
        emit(MapDataReceived());
      }
    } on Exception {
      emit(ErrorMarkerState("Ошибка"));
      emit(MapDataReceived());
    }
  }

  Future<void> _addMarker(AddMarkerEvent event,Emitter<MapState> emit) async{
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.post(
          Uri.parse(
              "https://themlyakov.ru:8080/user/mark/set?name=${event.name}&lat=${event.lat}&lon=${event.lon}&type=${event.type.getAsParameter()}"),
          headers: headers);
      if (response.statusCode == 200) {
        emit(MarkerAddedState());
        emit(MapDataReceived());
      } else {
        emit(ErrorMarkerState(
            json.decode(utf8.decode(response.body.codeUnits))['response']));
        emit(MapDataReceived());
      }
    } on Exception {
      emit(ErrorMarkerState("Ошибка"));
      emit(MapDataReceived());
    }
  }

  Future<void> _confirmMarker(ConfirmMarkerEvent event,Emitter<MapState> emit) async{
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.post(
          Uri.parse(
              "https://themlyakov.ru:8080/user/mark/confirm/${event.id}?isTruth=${event.isTruth?"true":"false"}"),
          headers: headers);
      if (response.statusCode == 200) {
        emit(MarkerConfirmedState());
        emit(MapDataReceived());
      } else {
        emit(ErrorMarkerState(
            json.decode(utf8.decode(response.body.codeUnits))['response']));
        emit(MapDataReceived());
      }
    } on Exception {
      emit(ErrorMarkerState("Ошибка"));
      emit(MapDataReceived());
    }
  }
}
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
Future<BitmapDescriptor> getRequestedMarkerIcon(ThemeMode mode) async {
  return await BitmapDescriptor.fromBytes(
      await _getBytesFromAsset(mode == ThemeMode.light?"assets/icons/requestdark.png":"assets/icons/requestlight.png", 64));
}
Future<BitmapDescriptor> getAcceptedMarkerIcon(ThemeMode mode,MarkerType searchType) async {
  return await BitmapDescriptor.fromBytes(
      await _getBytesFromAsset(mode == ThemeMode.light?searchType.getMarkerImageDark():searchType.getMarkerImageLight(), 64));
}

