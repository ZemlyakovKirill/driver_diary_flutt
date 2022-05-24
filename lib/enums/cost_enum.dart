enum CostType {
  REFUELING, WASHING, SERVICE, OTHER
}

extension CostTypeExt on CostType{

  String getAsParameter() {
    switch (this) {
      case CostType.REFUELING:
        return "REFUELING";
      case CostType.WASHING:
        return "WASHING";
      case CostType.SERVICE:
        return "SERVICE";
      case CostType.OTHER:
        return "OTHER";
    }
  }
  String getAsInput(){
      switch(this){
        case CostType.REFUELING:
          return "Заправка";
        case CostType.WASHING:
          return "Мойка";
        case CostType.SERVICE:
          return "Сервис";
        case CostType.OTHER:
          return "Другое";
      }
  }
}

CostType? getCostType(String serverType){
  if(serverType.contains("REFUELING")){
    return CostType.REFUELING;
  }else if(serverType.contains("WASHING")){
    return CostType.WASHING;
  }else if(serverType.contains("SERVICE")){
    return CostType.SERVICE;
  }else if(serverType.contains("OTHER")){
    return CostType.OTHER;
  }
  return null;
}
