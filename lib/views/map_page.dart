import 'dart:async';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:driver_diary/blocs/map/map_bloc.dart';
import 'package:driver_diary/blocs/theme/theme_bloc.dart';
import 'package:driver_diary/enums/marker_enum.dart';
import 'package:driver_diary/utils/map_styles.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  GoogleMapController? _controller;
  Completer<GoogleMapController> _completer = Completer();
  Set<Marker> _markers = Set.identity();


  @override
  Widget build(BuildContext context) {
    final _mapBloc = BlocProvider.of<MapBloc>(context);
    if (_mapBloc.state is MapInitial) {
      _mapBloc.add(GetLocationEvent());
    }
    return BlocConsumer<MapBloc, MapState>(listener: (context, state) async {
      if (state is MarkersReceivedState && _controller != null) {
        _markers = state.markers;
      } else if (state is ErrorMarkerState) {
        errorSnack(context, state.errorMessage);
      } else if (state is UserLocationReceivedState && _controller != null) {
        _controller!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(state.lat, state.lon), zoom: 15.0)));
      }
    }, builder: (context, state) {
      if (_mapBloc.lat != null && _mapBloc.lon != null) {
        return Stack(fit: StackFit.loose, children: [
          GoogleMap(
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(_mapBloc.lat!, _mapBloc.lon!), zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              final mode = BlocProvider
                  .of<ThemeBloc>(context)
                  .mode;
              _controller = controller;
              _completer.complete(_controller);
              if (mode == ThemeMode.dark) {
                _controller!.setMapStyle(darkStyle);
              } else {
                _controller!.setMapStyle(lightStyle);
              }
              _mapBloc.add(GetMarkersEvent());
            },
            onTap: (argument) async =>
            await _showAddingMarkerDialog(context,
                lat: argument.latitude, lon: argument.longitude),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () => _mapBloc.add(SetUserLocationEvent()),
                        icon: Icon(Icons.location_on_outlined,
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .color)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () =>
                            _mapBloc.add(
                                SetMarkerTypeEvent(markerType: MarkerType.GAS)),
                        icon: Icon(Icons.local_gas_station_outlined,
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .color)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () =>
                            _mapBloc.add(
                                SetMarkerTypeEvent(
                                    markerType: MarkerType.WASH)),
                        icon: Icon(Icons.local_car_wash_outlined,
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .color)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () =>
                            _mapBloc.add(
                                SetMarkerTypeEvent(
                                    markerType: MarkerType.SERVICE)),
                        icon: Icon(Icons.car_repair_outlined,
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .color)),
                  )
                ],
              )),
          Builder(
            builder: (context) {
              if (state is MarkerTappedState) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dy < -10) {
                      _mapBloc.add(MapInitialize());
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Тип:",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily: "Manrope"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    state.type,
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: "Manrope"),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Наименование:",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily: "Manrope"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    state.name,
                                    maxLines: 5,
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: "Manrope"),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .button!
                                    .color,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                              ),
                              padding: EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: null,
                                child: Text(
                                  "Проложить маршрут",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  width: 60,
                                  height: 4,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                );
              } else {
                return Container();
              }
            },
          ),
        ]);
      } else {
        return Container();
      }
    });
  }

  Future<void> _showMarkerInfo(BuildContext context,
      {required String name, required String type}) async {
    double? height = AppBar().preferredSize.height;
    await showAlignedDialog(
      context: context,
      targetAnchor: Alignment.topCenter,
      avoidOverflow: true,
      offset: Offset(0, height),
      barrierColor: Colors.transparent,
      transitionsBuilder: null,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy < -10) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Тип:",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: "Manrope"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              type,
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText2!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Наименование:",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: "Manrope"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              name,
                              maxLines: 5,
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText2!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .textTheme
                              .button!
                              .color,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: null,
                          child: Text(
                            "Проложить маршрут",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500,
                                fontSize: 9),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            width: 60,
                            height: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  Future<void> _showAddingMarkerDialog(BuildContext context,
      {required double lat, required double lon}) async {
    double? height = AppBar().preferredSize.height;
    await showAlignedDialog(
      context: context,
      targetAnchor: Alignment.topCenter,
      avoidOverflow: true,
      offset: Offset(0, height),
      barrierColor: Colors.transparent,
      transitionsBuilder: null,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(15))),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Тип",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ],
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          spacing: 10,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Наименование",
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText2!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: "Manrope"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .textTheme
                            .button!
                            .color,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: null,
                        child: Text(
                          "Проложить маршрут",
                          style: TextStyle(
                              color:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w500,
                              fontSize: 9),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: 100,
                        child: GestureDetector(
                          onTap: null,
                          child: Container(
                            color: Colors.grey,
                            width: 60,
                            height: 5,
                          ),
                        ))
                  ],
                ),
              )),
        );
      },
    );
  }
}
