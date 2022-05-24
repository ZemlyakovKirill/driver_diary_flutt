import 'dart:async';
import 'dart:developer';

import 'package:driver_diary/blocs/map/map_bloc.dart';
import 'package:driver_diary/blocs/theme/theme_bloc.dart';
import 'package:driver_diary/enums/marker_enum.dart';
import 'package:driver_diary/utils/map_styles.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as ml;

import '../widgets/MapSearchTypeButton.dart';
import '../widgets/stomp_listener.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _completer = Completer();

  Set<Marker> _acceptedMarkers = Set.identity();

  Set<Marker> _requestedMarkers = Set.identity();

  @override
  void dispose() async {
    super.dispose();
    GoogleMapController controller=await _completer.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mapBloc = BlocProvider.of<MapBloc>(context);
    if (_mapBloc.state is MapInitial) {
      _mapBloc.add(GetLocationEvent());
    }
    return StompListener(
      child: BlocConsumer<MapBloc, MapState>(listener: (context, state) async {
        if (state is MarkersReceivedState) {
          _acceptedMarkers = state.acceptedMarkers;
          _requestedMarkers = state.requestedMarkers;
        } else if(state is MapInitial){
          GoogleMapController controller=await _completer.future;
        } else if(state is MapTappedState){
              final icon=await getRequestedMarkerIcon(BlocProvider.of<ThemeBloc>(context).mode);
              GoogleMapController controller=await _completer.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(state.lat, state.lon), zoom: 15.0)));
        }else if(state is MarkerAddedState){
          infoSnack(context, "Метка успешно добавлена");
        }else if(state is MarkerConfirmedState){
          infoSnack(context, "Ваш голос учтен");
        }
        else if (state is ErrorMarkerState) {
          errorSnack(context, state.errorMessage);
        } else if (state is UserLocationReceivedState) {
          GoogleMapController controller=await _completer.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(state.lat, state.lon), zoom: 15.0)));
        }
      }, builder: (context, state) {
        if (_mapBloc.lat != null && _mapBloc.lon != null) {
          log(_acceptedMarkers.where((element) => element.markerId == MarkerId("adding_temp")).toString());
          return Stack(fit: StackFit.expand, children: [
            GoogleMap(
              markers: _acceptedMarkers.union(_requestedMarkers),
              mapType: _mapBloc.mapType,
              initialCameraPosition: CameraPosition(
                  target: LatLng(_mapBloc.lat!, _mapBloc.lon!), zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                final mode = BlocProvider
                    .of<ThemeBloc>(context)
                    .mode;
                if (mode == ThemeMode.dark) {
                  controller.setMapStyle(darkStyle);
                } else {
                  controller.setMapStyle(lightStyle);
                }
                _completer.complete(controller);
                _mapBloc.add(GetMarkersEvent(mode));
              },
              onCameraMove: (pos){
              },
              trafficEnabled: _mapBloc.showTraffic,
              onTap: (argument) async =>
              {
                _mapBloc
                    .add(MapTappedEvent(argument.latitude, argument.longitude))
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
            ),
            Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme
                                .of(context)
                                .primaryColor,
                            shape: BoxShape.rectangle),
                        child: MapSearchTypeButton(
                            initialType: MarkerType.gas)),
                  ],
                )),
                AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          SizeTransition(
                            sizeFactor: anim,
                            child: child,
                          ),
                      layoutBuilder: (currentChild, previousChildren) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          ),
                      child: state is MarkerTappedState
                          ? MarkerInfo()
                          : state is MapTappedState
                          ? AddMarker(lat: state.lat, lon: state.lon)
                          : Container(),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                      SizeTransition(
                        sizeFactor: anim,
                        child: child,
                      ),
              layoutBuilder: (currentChild, previousChildren) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      ),
              child: state is RequestedMarkerTappedState
                      ? ConfirmMarker()
                      : Container(),),
                  ],
                ),
          ]);
        } else {
          return Container();
        }
      }),
    );
  }
}

class MarkerInfo extends StatefulWidget {
  const MarkerInfo({Key? key}) : super(key: key);

  @override
  State createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<MarkerInfo> {
  late MapBloc _mapBloc;

  final ValueNotifier<bool> _showAvailableMaps=ValueNotifier<bool>(false);
  late List<ml.AvailableMap> _availableMaps;

  @override
  void initState() {
    _mapBloc = BlocProvider.of<MapBloc>(context);
    ml.MapLauncher.installedMaps.then((value) => _availableMaps=value);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    var state = _mapBloc.state as MarkerTappedState;
    return StompListener(
      child: GestureDetector(
        key: ValueKey<int>(1),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          state.type.getAsInput(),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Container(
                          width: width * 0.4,
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
                      ),
                    ],
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showAvailableMaps,
                    builder: (context,value,_) {
                      return Container(
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
                          onTap: ()=>_showAvailableMaps.value=!_showAvailableMaps.value,
                          child: Text(
                            value?"Отмена":"Проложить маршрут",
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
                      );
                    }
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showAvailableMaps,
                    builder: (context,value,_) {
                      return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                          child: value
                          ?Padding(
                            padding: const EdgeInsets.symmetric(vertical:10.0),
                            child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 10,
                                  children: _availableMaps
                                      .map((e) => GestureDetector(
                                    onTap: ()async => await e.showDirections(
                                        destination: ml.Coords(state.lat,state.lon ),
                                      destinationTitle: state.name,
                                    ),
                                        child: SvgPicture.asset(
                                    e.icon,
                                    height: 50,
                                    width: 50,
                                  ),
                                      )).toList() ,
    ),
                          ):Container(),
                        transitionBuilder: (child,anim)=>SizeTransition(sizeFactor: anim,child: child,),
                          );
                    }
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
      ),
    );
  }
}

class ConfirmMarker extends StatefulWidget {
  const ConfirmMarker({Key? key}) : super(key: key);

  @override
  State<ConfirmMarker> createState() => _ConfirmMarkerState();
}

class _ConfirmMarkerState extends State<ConfirmMarker> {
  late MapBloc _mapBloc;


  @override
  void initState() {
    _mapBloc = BlocProvider.of<MapBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var state=_mapBloc.state as RequestedMarkerTappedState;
    return GestureDetector(
      key: ValueKey<int>(3),
      onPanUpdate: (details) {
        if (details.delta.dy > 10) {
          _mapBloc.add(MapInitialize());
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(15))),
                  width: 60,
                  height: 4,
                ),
              ],
            ),
            Text("Метка действительно существует?",
              style: TextStyle(
                  fontFamily: "Manrope",
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodyText1!
                      .color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      _mapBloc.add(ConfirmMarkerEvent(isTruth: false, id: state.id));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.redAccent
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      )
                    ),
                    child: Text(
                    "Не существует",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                        fontSize: 14,
                        color: Colors.black54
                    ),
                  ),),
                  TextButton(
                    onPressed: () {
                      _mapBloc.add(ConfirmMarkerEvent(isTruth: false, id: state.id));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    ),
                    child: Text(
                      "Существует",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Manrope",
                          fontSize: 14,
                          color: Colors.black54
                      ),
                    ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class AddMarker extends StatefulWidget {
  AddMarker({Key? key, required this.lat, required this.lon}) : super(key: key);
  final double lat;
  final double lon;

  @override
  _AddMarkerState createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  late MapBloc _mapBloc;

  MarkerType? _markerType;
  TextEditingController _nameController=TextEditingController();

  @override
  void initState() {
    _mapBloc = BlocProvider.of<MapBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    var state = _mapBloc.state as MapTappedState;
    return StompListener(
      child: GestureDetector(
        key: ValueKey<int>(4),
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text("Добавление маркера",
                      style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme
                              .of(context)
                              .textTheme
                              .bodyText1!
                              .color
                      ),),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Тип",
                              style: TextStyle(
                                  color:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<MarkerType>(
                              value: _markerType,
                              icon: null,
                              dropdownElevation: 0,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontFamily: "Manrope",
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                              ),
                              customButton: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .canvasColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text(
                                    _markerType!=null?_markerType!.getAsInput():"Выберите тип"
                                ),
                              ),
                              isDense: true,
                              iconSize: 0.0,
                              dropdownWidth: 150,
                              buttonWidth: 150,
                              alignment: Alignment.center,
                              items: MarkerType.values
                                  .map((e) =>
                                  DropdownMenuItem<MarkerType>(
                                      value: e,
                                      child: Center(
                                        child: Text(
                                          e.getAsInput(),
                                          style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontFamily: "Manrope",
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _markerType = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Наименование",
                              style: TextStyle(
                                  color:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                          Container(
                            width: width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme
                                  .of(context)
                                  .canvasColor,
                            ),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Theme.of(context).textTheme.bodyText1!.color,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                hintText: "Газпром АЗС",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
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
                        onTap: (){
                          if(_nameController.text.isEmpty){
                            errorSnack(context, "Наименование не должно быть пустым");
                            return;
                          }else if(_nameController.text.length>100){
                            errorSnack(context, "Наименование не должно превышать 100 символов");
                            return;
                          }
                          if(_markerType==null){
                            errorSnack(context, "Тип метки не может быть пустым");
                            return;
                          }
                          _mapBloc.add(AddMarkerEvent(name: _nameController.text,lat:state.lat,lon:state.lon,type: _markerType!));
                        },
                        child: Text(
                          "Добавить",
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        width: 60,
                        height: 4,
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
