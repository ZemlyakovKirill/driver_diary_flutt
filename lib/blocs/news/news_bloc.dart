import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/news_model.dart';
import 'package:driver_diary/views/news_filter.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  List<News>? news;
  NewsSearchFilter searchFilter=NewsSearchFilter.author;
  NewsBloc() : super(NewsInitial()) {
    on<GetNewsEvent>((event, emit) async => await _getNewsData(emit));
    on<NewsSearchFilterChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setInt("news_search_filter",event.searchFilter.index);
      searchFilter=event.searchFilter;
      emit(NewsSearchFilterChangedState());
    });

    SharedPreferences.getInstance().then((value){
      if(value.containsKey("news_search_filter")){
        add(NewsSearchFilterChangedEvent(
            NewsSearchFilter.values[value.getInt("news_search_filter")!]
        ));
      }
    });

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
      final response = await http.get(Uri.parse("https://themlyakov.ru:8080/user/news/all"
          "?sortBy=${searchFilter.asParameter()}"),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        news=(responseJson["response"] as List<dynamic>).map((e) => News.fromJson(e)).toList();
        emit(NewsReceivedState());
      }else{
        emit(NewsErrorState(responseJson["response"] as String));
      }
    }on Exception catch (e){
      log(e.toString());
      emit(NewsErrorState("Ошибка"));
    }

  }
}
