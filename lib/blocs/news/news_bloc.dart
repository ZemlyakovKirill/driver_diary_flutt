import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/news_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  List<News>? news;
  NewsBloc() : super(NewsInitial()) {
    on<GetNewsEvent>((event, emit) async => await _getNewsData(emit));
  }

  @override
  void onChange(Change<NewsState> change) {
    super.onChange(change);
    log("NewsBloc -> "+change.nextState.toString());
  }



  Future<void> _getNewsData(Emitter<NewsState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/news/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        news=(responseJson["response"] as List<dynamic>).map((e) => News.fromJson(e)).toList();
        emit(NewsReceivedState());
      }else{
        emit(NewsErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(NewsErrorState("Ошибка"));
    }

  }
}
