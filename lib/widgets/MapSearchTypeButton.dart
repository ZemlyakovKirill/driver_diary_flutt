import 'dart:developer';

import 'package:driver_diary/enums/marker_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/map/map_bloc.dart';
import '../blocs/theme/theme_bloc.dart';

class MapSearchTypeButton extends StatefulWidget {
  MapSearchTypeButton({Key? key, required this.initialType}) : super(key: key);
  MarkerType initialType;

  @override
  _MapSearchTypeState createState() => _MapSearchTypeState();
}

class _MapSearchTypeState extends State<MapSearchTypeButton> {
  bool _isMarkersShowing = false;
  late MarkerType _currentType;
  @override
  void initState() {
    _currentType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    List<MarkerType> marksExceptCurrent = MarkerType.values.toList()
      ..remove(_currentType);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isMarkersShowing?Column(
                  children: marksExceptCurrent
                      .map((e) => Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: InkWell(
                      onTap: () => _typeHasChanged(e),
                      child: Icon(
                        e.getMarkerIconData(),
                        size: 35,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ))
                      .toList()):const SizedBox(height: 0,width: 0,),
              transitionBuilder: (child,anim)=>SizeTransition(
                axis: Axis.vertical,
                sizeFactor: anim,
                child: child,),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isMarkersShowing = !_isMarkersShowing;
                });
              },
              child: Icon(
                _currentType.getMarkerIconData(),
                size: 35,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            )
          ],
        ),
      ],
    );
  }

  void _typeHasChanged(MarkerType newMarkerType) {
    var mode = BlocProvider.of<ThemeBloc>(context).mode;
    BlocProvider.of<MapBloc>(context)
        .add(SetMarkerTypeEvent(
      mode: mode,
        markerType: newMarkerType));
    setState(() {
      _currentType = newMarkerType;
      _isMarkersShowing = false;
    });
  }
}
