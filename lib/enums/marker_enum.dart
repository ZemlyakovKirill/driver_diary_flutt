
enum MarkerType{
  GAS,
  WASH,
  SERVICE
}

extension MarkerTypeExtension on MarkerType{
  String getAsParameter(){
    switch(this){
      case MarkerType.GAS:
        return "GASSTATION";
      case MarkerType.WASH:
        return "CARWASH";
      case MarkerType.SERVICE:
        return "CARSERVICE";
    }
  }

  String getMarkerIcon(){
    switch(this){
      case MarkerType.GAS:
        return "assets/icons/gasmarker.png";
      case MarkerType.WASH:
        return "assets/icons/washmarker.png";
      case MarkerType.SERVICE:
        return "assets/icons/servicemarker.png";
    }
  }
}