import 'package:driver_diary/views/edit_profile_page.dart';
import 'package:driver_diary/views/edit_vehicle_page.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/vehicle/vehicle_bloc.dart';
import '../models/vehicle_model.dart';



class CarPanel extends StatefulWidget {

  Vehicle vehicle;
  double closedHeight = 10;
  double openedHeight = double.infinity;
  double width = double.infinity;

  CarPanel(
      {Key? key, required this.vehicle,}) :super(key:key);

  @override
  _CarPanelState createState() => _CarPanelState();
}

class _CarPanelState extends State<CarPanel> {

  final ExpandableController _expandableController=ExpandableController();



  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    final _bloc=BlocProvider.of<VehicleBloc>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).canvasColor),
      width: double.infinity,
      child: ExpandableNotifier(
        controller: _expandableController,
        child: ExpandablePanel(
          theme: ExpandableThemeData(
              crossFadePoint: 0,
              tapBodyToCollapse: true,
              tapBodyToExpand: true,
              hasIcon: false),
          collapsed: Text(
            '${widget.vehicle.mark} ${widget.vehicle.model}'.toUpperCase(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: "Manrope",
                color: Theme.of(context).textTheme.bodyText1!.color),
          ),
          expanded: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisSize: MainAxisSize.max, children: [
                Text(
                  'Марка',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                  child: Text(
                    widget.vehicle.mark,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Icon(Icons.edit,
                          size: 20,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color),
                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditVehiclePage(bloc: _bloc, vehicle: widget.vehicle))),
                    ),
                  ),
                )
              ]),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Модель',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.model,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Поколение',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.generation??"N/A",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Расход город',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.consumptionCity.toString(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Расход шоссе',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.consumptionRoute.toString(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Расход смешанный цикл',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.consumptionMixed.toString(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Запас топлива',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.fuelCapacity.toString(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Номерной знак',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      widget.vehicle.licensePlateNumber??"N/A",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        child: Icon(Icons.delete,
                            size: 20,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color),
                        onTap: ()=>_bloc.add(DeleteVehicleEvent(widget.vehicle)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
