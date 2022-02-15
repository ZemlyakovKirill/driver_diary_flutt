import 'package:driver_diary/models/vehicle_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Note {
  int costID;
  String? description;
  double? value;
  String? costType;
  DateTime endDate;
  bool isCost;
  bool isCompleted;
  Vehicle? vehicle;

  Note(
      {required this.costID,
      this.description,
      this.value,
      this.costType,
      required this.endDate,
      required this.isCost,
      required this.isCompleted,
      this.vehicle});

  Note.fromJson(Map<String, dynamic> json)
      : costID = int.parse(json["id"].toString()),
        description = json["description"].toString(),
        value = double.tryParse(json["value"].toString()),
        endDate = DateFormat("MMM d, yyyy hh:mm:ss aa")
            .parse(json['endDate'].toString()),
        isCost = json['isCost'] as bool,
        isCompleted = json['isCompleted'] as bool,
        costType = "Другое",
        vehicle = json["userVehicle"]!=null?Vehicle.fromJson(json["userVehicle"]["vehicle"]):null{
    costType=_getType(json["typeCost"].toString());
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
        child: Builder(builder: (context) {
          if (isCost) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      costType!,
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
                        '${value!.toStringAsFixed(2)} Р',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        DateFormat("hh:mm").format(endDate),
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
                      '${vehicle!.mark.toUpperCase()} ${vehicle!.model.toUpperCase()}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 14,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      DateFormat("dd MMMM yy").format(endDate),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color,
                          fontSize: 12,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            );
          }else{
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Заметка",
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
                        '$description',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        DateFormat("hh:mm").format(endDate),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("dd MMMM yy").format(endDate),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color,
                          fontSize: 12,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            );
          }
        }));
  }
}
