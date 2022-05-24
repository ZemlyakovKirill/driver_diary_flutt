

extension StringBoolExt on String{
  bool toBool(){
    return toLowerCase()=='true';
  }
}