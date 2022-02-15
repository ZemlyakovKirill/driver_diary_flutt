class User {
  int id;
  String username;
  String lname;
  String fname;
  String? phone;
  String email;

  User(
      {required this.id,
      required this.username,
      required this.lname,
      required this.fname,
      this.phone,
      required this.email});

  User.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        username = json['username'].toString(),
        lname = json['lastName'].toString(),
        fname = json['firstName'].toString(),
        email = json['email'].toString(),
        phone = json.containsKey('telnum') ? json['telnum'].toString() : 'N/A';

  User.empty()
      : id = 0,
        username = "N/A",
        lname = "N/A",
        fname = "N/A",
        email = "N/A",
        phone = "N/A";

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
