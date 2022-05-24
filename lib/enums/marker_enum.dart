
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/avd.dart';

enum MarkerType{
  gas,
  wash,
  service,
  methane,
  charge,
}

extension MarkerTypeExtension on MarkerType{
  String getAsParameter(){
    switch(this){
      case MarkerType.gas:
        return "GAS";
      case MarkerType.wash:
        return "WASH";
      case MarkerType.service:
        return "SERVICE";
      case MarkerType.methane:
        return "METHANE";
      case MarkerType.charge:
        return "CHARGE";
    }
  }

  String getMarkerImageLight(){
    switch(this){
      case MarkerType.gas:
        return "assets/icons/gaslight.png";
      case MarkerType.wash:
        return "assets/icons/washlight.png";
      case MarkerType.service:
        return "assets/icons/servicelight.png";
      case MarkerType.methane:
        return "assets/icons/methanelight.png";
      case MarkerType.charge:
        return "assets/icons/lightninglight.png";
    }
  }

  IconData getMarkerIconData(){
    switch(this){
      case MarkerType.gas:
        return  MyCustomIcons.gas_marker;
      case MarkerType.wash:
        return MyCustomIcons.wash_marker;
      case MarkerType.service:
        return MyCustomIcons.service_marker;
      case MarkerType.methane:
        return MyCustomIcons.methane_marker;
      case MarkerType.charge:
        return MyCustomIcons.charge_marker;
    }
  }

  String getMarkerImageDark(){
    switch(this){
      case MarkerType.gas:
        return "assets/icons/gasdark.png";
      case MarkerType.wash:
        return "assets/icons/washdark.png";
      case MarkerType.service:
        return "assets/icons/servicedark.png";
      case MarkerType.methane:
        return "assets/icons/methanedark.png";
      case MarkerType.charge:
        return "assets/icons/lightningdark.png";
    }
  }

  String getAsInput(){
    switch(this){
      case MarkerType.gas:
        return "Заправка бензин";;
      case MarkerType.wash:
        return "Мойка";
      case MarkerType.service:
        return "Автосервис";
      case MarkerType.methane:
        return "Газовая заправка";
      case MarkerType.charge:
        return "Зарядная станция";
    }
  }
}

MarkerType? getType(String stringType){
  if(stringType.contains("GAS")){
    return MarkerType.gas;
  }
  if(stringType.contains("WASH")){
    return MarkerType.wash;
  }
  if(stringType.contains("SERVICE")){
    return MarkerType.service;
  }
  if(stringType.contains("METHANE")){
    return MarkerType.methane;
  }
  if(stringType.contains("CHARGE")){
    return MarkerType.charge;
  }
  return null;
}