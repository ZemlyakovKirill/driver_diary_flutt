import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/src/provider.dart';

class CarPanel {
  int id;
  double closedHeight = 10;
  double openedHeight = double.infinity;
  double width = double.infinity;
  String mark;
  String model;
  String generation = "N/A";
  double consumptionRoute;
  double consumptionCity;
  double consumptionMixed;
  double fuelCapacity;
  String plateNumber = "N/A";

  CarPanel(
      {double? width,
        required this.id,
      required this.mark,
      required this.model,
      String? generation,
      required this.consumptionRoute,
      required this.consumptionCity,
      required this.consumptionMixed,
      required this.fuelCapacity,
      String? plateNumber}) {
    if (generation != null) {
      this.generation = generation;
    }
    if (plateNumber != null) {
      this.plateNumber = plateNumber;
    }
  }

  Widget panel(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          // CustomSlidableAction(
          //   backgroundColor: Colors.transparent,
          //     onPressed: (_)=>context.read<>().deleteVehicle(context, id),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Color.fromRGBO(240,87,77, 1)
          //       ),
          //       child: Center(
          //         child:Icon(
          //           Icons.delete,
          //           color: Theme.of(context).textTheme.bodyText1!.color,
          //         )
          //       ),
          //     ))
        ],
        
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).canvasColor),
        width: double.infinity,
        child: ExpandableNotifier(
          child: ExpandablePanel(
            theme: ExpandableThemeData(
                crossFadePoint: 0,
                tapBodyToCollapse: true,
                tapBodyToExpand: true,
                hasIcon: false),
            collapsed: Text(
              '$mark $model'.toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Manrope",
                  color: Colors.black),
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
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Text(
                      mark,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Color(0xFF444444),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Модель',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        model,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        generation,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        consumptionCity.toString(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        consumptionRoute.toString(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        consumptionMixed.toString(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        fuelCapacity.toString(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
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
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        plateNumber,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFF444444),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
