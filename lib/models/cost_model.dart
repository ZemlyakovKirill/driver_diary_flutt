import 'dart:developer';

import 'package:driver_diary/blocs/cost/cost_bloc.dart';
import 'package:driver_diary/models/vehicle_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../enums/cost_enum.dart';

class Cost {
  int costId;
  CostType type;
  double value;
  DateTime date;
  Vehicle vehicle;
  String prettyDate;

  Cost({required this.costId, required this.type, required this.value, required this.date, required this.vehicle})
    :prettyDate=timeago.format(DateTime.now(),locale:"ru",allowFromNow: true){
    prettyDate=timeago.format(date,locale:"ru",allowFromNow: true);
  }

  Cost.fromJson(Map<String, dynamic> json)
      : costId = int.parse(json["costId"].toString()),
        type = CostType.OTHER,
        value = double.parse(json["value"].toString()),
        prettyDate=timeago.format(DateTime.now(),locale:"ru"),
        date = DateFormat("MMM d, yyyy, hh:mm:ss aa")
            .parse(json['date'].toString()),
        vehicle = Vehicle.fromJson(json['userVehicle']['vehicle']){
    type=getCostType(json["type"].toString())??CostType.OTHER;
    prettyDate=timeago.format(date,locale:"ru",allowFromNow: true);
  }

  String _getType(String serverType){
    log(serverType);
    if(serverType.contains("REFUELING")){
      return "Заправка";
    }else if(serverType.contains("WASHING")){
      return "Мойка";
    }else if(serverType.contains("SERVICE")){
      return "Сервис";
    }else{
      return "Другое";
    }
  }

  Widget getAsWidget(BuildContext context,CostBloc costBloc) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).canvasColor),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type.getAsInput(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 12,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: ()=>costBloc.add(CostDeleteEvent(this)),
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$value Р',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 14,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${vehicle.mark.toUpperCase()} ${vehicle.model.toUpperCase()}',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 14,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  prettyDate,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 12,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ));
  }
}
