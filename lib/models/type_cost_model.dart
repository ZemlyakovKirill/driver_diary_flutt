import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypeCost {
  String textType;
  Icon type;
  double value;
  int count;

  TypeCost(this.type, this.textType, this.value, this.count);

  TypeCost.fromJson(Map<String, dynamic> json)
      : type = Icon(
          Icons.more_horiz_outlined,
          color: Colors.greenAccent,
        ),
        textType = "Другое",
        value = double.parse(json["value"].toString()),
        count = int.parse(json["count"].toString()) {
    type = _getIconType(json["type"].toString());
    textType = _getType(json["type"].toString());
  }

  String _getType(String serverType){
    if(serverType.contains("REFUELING")){
      return "Заправка";
    }else if(serverType.contains("WASHING")){
      return "Мойка";
    }else if(serverType.contains("SERVICE")){
      return "Сервис";
    }else if(serverType.contains("OTHER")){
      return "Другое";
    }else{
      return "Другое";
    }
  }

  Icon _getIconType(String serverType) {
    if(serverType.contains("REFUELING")){
      return Icon(
        Icons.local_gas_station_outlined,
        color: Colors.redAccent,
      );
    }else if(serverType.contains("WASHING")){
      return Icon(
        Icons.local_car_wash_outlined,
        color: Colors.blueAccent,
      );
    }else if(serverType.contains("SERVICE")){
      return Icon(
        Icons.car_repair_outlined,
        color: Colors.yellowAccent,
      );
    }else if(serverType.contains("OTHER")){
      return Icon(
        Icons.more_horiz_outlined,
        color: Colors.greenAccent,
      );
    }else{
      return Icon(
        Icons.more_horiz_outlined,
        color: Colors.greenAccent,
      );
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textType,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontSize: 12,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  type,
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
            Text(
              'Кол-во: $count',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontSize: 12,
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
