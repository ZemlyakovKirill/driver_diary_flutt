import 'package:driver_diary/models/vehicle_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Cost {
  int costId;
  String type;
  double value;
  DateTime date;
  Vehicle vehicle;

  Cost(this.costId, this.type, this.value, this.date, this.vehicle);

  Cost.fromJson(Map<String, dynamic> json)
      : costId = int.parse(json["costId"].toString()),
        type = "Другое",
        value = double.parse(json["value"].toString()),
        date = DateFormat("MMM d, yyyy hh:mm:ss aa")
            .parse(json['date'].toString()),
        vehicle = Vehicle.fromJson(json['userVehicle']['vehicle']){
    type=_getType(json["type"].toString());
  }

  String _getType(String serverType){
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

  Widget getAsWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 12,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: null,
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
                  Text(
                    DateFormat("hh:mm").format(date),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 12,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w500),
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
                  DateFormat("dd MMMM yy").format(date),
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
