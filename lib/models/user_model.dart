import 'package:driver_diary/widgets/extens.dart';

class User {
  int id;
  String username;
  String lname;
  String fname;
  String? phone;
  String email;
  bool isVk;
  bool isGoogle;

  User(
      {required this.id,
      required this.username,
      required this.lname,
      required this.fname,
      this.phone,
      required this.email,
        required this.isGoogle,
        required this.isVk
      });

  User.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        username = json['username'].toString(),
        lname = json['lastName'].toString(),
        fname = json['firstName'].toString(),
        email = json['email'].toString(),
        phone = json.containsKey('telnum') ? json['telnum'].toString() : "",
        isVk=json["isVk"].toString().toBool(),
        isGoogle=json["isGoogle"].toString().toBool();

  User.from(User another)
    : id=another.id,
      username=another.username,
      lname=another.lname,
      fname=another.fname,
      email=another.email,
      isGoogle=another.isGoogle,
      isVk=another.isVk,
      phone=another.phone;

  User.empty()
      : id = 0,
        username = "",
        lname = "",
        fname = "",
        email = "",
        isGoogle=false,
        isVk=false,
        phone = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          lname == other.lname &&
          fname == other.fname &&
          phone == other.phone &&
          email == other.email;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      lname.hashCode ^
      fname.hashCode ^
      phone.hashCode ^
      email.hashCode;
}
