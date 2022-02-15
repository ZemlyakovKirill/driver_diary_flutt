import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isUserAuthorized(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("token")) {
    return await isTokenValid(context, prefs.getString("token"));
  }
  return false;
}

Future<bool> isTokenValid(BuildContext context, String? token) async {
  Map<String, String> headers = Map.identity();

  if (token != null) {
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
  }
  print(headers);
  try {
    final response = await http
        .post(Uri.parse("https://themlyakov.ru:8080/user/testtoken"),
            headers: headers)
        .timeout(Duration(seconds: 10));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
  } on Exception{
    return false;
  }
  return false;
}
