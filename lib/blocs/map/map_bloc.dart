import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:driver_diary/enums/marker_enum.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:flutter/cupertino.dart';
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
  MarkerType searchType = MarkerType.GAS;
  Set<Marker>? markers;

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

    on<GetMarkersEvent>((event, emit) async => await _getMarkers(event, emit));

    on<MarkerTappedEvent>((event, emit) {
      emit(MarkerTappedState(
          lat: event.lat,
          lon: event.lon,
          type: event.type,
          name: event.name,
          additional: event.additional));
    });

    on<SetMarkerTypeEvent>((event, emit) {
      searchType = event.markerType;
      add(GetMarkersEvent());
    });
  }

  @override
  void onChange(Change<MapState> change) {
    super.onChange(change);
    log("MapBloc -> " + change.nextState.toString());
  }

  Future<void> _getMarkers(
      GetMarkersEvent event, Emitter<MapState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.post(
          Uri.parse(
              "https://themlyakov.ru:8080/user/mark/get?lat=$lat&lon=$lon&type=${searchType.getAsParameter()}"),
          headers: headers,
          encoding: Encoding.getByName("UTF-8"));
      if (response.statusCode == 200) {
        final responseList =
            json.decode(utf8.decode(response.body.codeUnits))['response']
                as List<dynamic>;
        log(responseList.toString());
        final icon = await BitmapDescriptor.fromBytes(
            await _getBytesFromAsset(searchType.getMarkerIcon(), 64));
        emit(MarkersReceivedState(responseList
            .map((e) => Marker(
                markerId: MarkerId(e["lat"].toString() + e["lon"]!.toString()),
                position: LatLng(e["lat"], e["lon"]),
                icon: icon,
                onTap: () {
                  add(MarkerTappedEvent(
                    lat: e["lat"],
                    lon: e["lon"],
                    name: e["name"],
                    type: e["type"],
                  ));
                }))
            .toSet()));
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

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
