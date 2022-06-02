

enum Month{
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december
}

extension MonthExt on Month{
  int getAsInt(){
    switch(this){
      case Month.january:
        return 1;
      case Month.february:
        return 2;
      case Month.march:
        return 3;
      case Month.april:
        return 4;
      case Month.may:
        return 5;
      case Month.june:
        return 6;
      case Month.july:
        return 7;
      case Month.august:
        return 8;
      case Month.september:
        return 9;
      case Month.october:
        return 10;
      case Month.november:
        return 11;
      case Month.december:
        return 12;
    }

  }

  String getAsParameter(){
    switch(this){
      case Month.january:
        return "Январь";
      case Month.february:
        return "Февраль";
      case Month.march:
        return "Март";
      case Month.april:
        return "Апрель";
      case Month.may:
        return "Май";
      case Month.june:
        return "Июнь";
      case Month.july:
        return "Июль";
      case Month.august:
        return "Август";
      case Month.september:
        return "Сентябрь";
      case Month.october:
        return "Октябрь";
      case Month.november:
        return "Ноябрь";
      case Month.december:
        return "Декабрь";
    }

  }
}

Month getMonthFromInt(int value){
  switch(value){
    case 1:
      return Month.january;
    case 2:
      return Month.february;
    case 3:
      return Month.march;
    case 4:
      return Month.april;
    case 5:
      return Month.may;
    case 6:
      return Month.june;
    case 7:
      return Month.july;
    case 8:
      return Month.august;
    case 9:
      return Month.september;
    case 10:
      return Month.october;
    case 11:
      return Month.november;
    case 12:
      return Month.december;
    default:
      return Month.january;
  }
}