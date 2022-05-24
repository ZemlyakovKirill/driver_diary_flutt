import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypeCost {
  String textType;
  Color typeColor;
  double value;

  TypeCost(this.typeColor, this.textType, this.value);

  TypeCost.fromJson(Map<String, dynamic> json)
      : typeColor = Colors.green,
        textType = "Другое",
        value = double.parse(json["value"].toString()) {
    typeColor = _getColorType(json["type"].toString());
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

  Color _getColorType(String serverType) {
    if(serverType.contains("REFUELING")){
      return Colors.redAccent;
    }else if(serverType.contains("WASHING")){
      return Colors.blueAccent;
    }else if(serverType.contains("SERVICE")){
      return Colors.yellowAccent;
    }else if(serverType.contains("OTHER")){
      return Colors.greenAccent;
    }else{
      return Colors.greenAccent;
    }
  }

  // Widget getAsWidget(BuildContext context) {
  //   return Container(
  //       margin: EdgeInsets.only(top: 10),
  //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15),
  //           color: Theme.of(context).primaryColor),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             textType,
  //             style: TextStyle(
  //                 color: Theme.of(context).textTheme.bodyText2!.color,
  //                 fontSize: 12,
  //                 fontFamily: "Manrope",
  //                 fontWeight: FontWeight.w500),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 5),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 type,
  //                 Text(
  //                   '$value Р',
  //                   style: TextStyle(
  //                       color: Theme.of(context).textTheme.bodyText1!.color,
  //                       fontSize: 14,
  //                       fontFamily: "Manrope",
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}
