import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<http.Response> secureRequest(BuildContext context,
    Future<http.Response> Function() request) async {
  try {
    final response = await request.call().timeout(Duration(seconds: 10));
    return http.Response(response.body.runes.string, response.statusCode,
        headers: response.headers);
  } on TimeoutException {
    return http.Response.bytes(
        utf8.encode("{\"response\":\"Превышено время ожидания\"}"),
        408,
        headers: {"Content-Type": "application/json; charset=utf-8"});
  } on SocketException {
    return http.Response.bytes(
        utf8.encode("{\"response\":\"Не получен ответ от сервера\"}"),
        503,
        headers: {"Content-Type": "application/json; charset=utf-8"});
  } on Error catch (e) {
    log(e.toString());
    return http.Response.bytes(
        utf8.encode("{\"response\":\"Ошибка, обратитесь к администратору\"}"),
        500,
        headers: {"Content-Type": "application/json; charset=utf-8"});
  }
}
