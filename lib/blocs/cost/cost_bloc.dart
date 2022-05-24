import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/enums/cost_enum.dart';
import 'package:driver_diary/models/cost_model.dart';
import 'package:driver_diary/models/type_cost_model.dart';
import 'package:driver_diary/views/cost_filter.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../enums/month_enum.dart';
import '../../utils/http_utils.dart';

part 'cost_event.dart';
part 'cost_state.dart';

class CostBloc extends Bloc<CostEvent, CostState> {
  List<Month>? _months;
  Map<Month,List<Cost>> _listCosts=Map.identity();
  Map<Month,List<TypeCost>> _typeCosts=Map.identity();
  CostSearchFilter searchFilter=CostSearchFilter.value;
  Direction direction=Direction.asc;

  List<Month>? get months => _months;

  CostBloc() : super(CostInitial()) {
    on<CostListGetEvent>((event, emit) async => await _getListCost(event,emit));
    on<CostMonthsGetEvent>((event, emit) async => await _getMonthsEvent(emit));
    on<CostTypeGetEvent>((event, emit) async => await _getTypeCost(event,emit));
    on<CostAddEvent>((event, emit) async => await _addCost(event, emit));
    on<CostDirectionChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setBool("cost_search_direction",event.direction==Direction.asc?true:false);
      direction=event.direction;
      emit(CostDirectionChangedState());
    });
    on<CostSearchFilterChangedEvent>((event, emit) async {
      final prefs=await SharedPreferences.getInstance();
      prefs.setInt("cost_search_filter",event.searchFilter.index);
      searchFilter=event.searchFilter;
      emit(CostSearchFilterChangedState());
    });
    on<CostDeleteEvent>((event,emit)async=>await  _deleteCost(event,emit));

    SharedPreferences.getInstance().then((value){
      if(value.containsKey("cost_search_direction")){
        add(CostDirectionChangedEvent(
          value.getBool("cost_search_direction")!?Direction.asc:Direction.desc
        ));
      }
      if(value.containsKey("cost_search_filter")){
        add(CostSearchFilterChangedEvent(
          CostSearchFilter.values[value.getInt("cost_search_filter")!]
        ));
      }
    });
  }


  @override
  void onChange(Change<CostState> change) {
    super.onChange(change);
    log("CostBloc -> "+change.nextState.toString());
  }


  Future<void> _getListCost(CostListGetEvent event, Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.get(
          Uri.parse("https://themlyakov.ru:8080/user/cost/list/all?month=${event.month.getAsInt()}"
              "&sortBy=${searchFilter.asParameter()}"
              "&direction=${direction.asParameter()}"),
          headers: headers);
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        var costs = (responseJson["response"] as List<dynamic>)
            .map((e) => Cost.fromJson(e))
            .toList();
        _listCosts[event.month]=costs;
        emit(CostListDataReceived());
      } else {
        emit(CostErrorState(responseJson["response"] as String));
      }
    }on Exception catch (e){
      log(e.toString());
      emit(CostErrorState("Ошибка"));
    }
  }

  Future<void> _getMonthsEvent(Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.get(
          Uri.parse("https://themlyakov.ru:8080/user/cost/type/month/get"),
          headers: headers);
      final responseJson = json.decode(utf8.decode(response.body.codeUnits))
      as Map<String, dynamic>;

      if (response.statusCode == 200) {
        _months=(responseJson["response"] as List<dynamic>)
        .map((e) => getMonthFromInt(int.parse(e.toString()))).toList();
        _typeCosts=Map.identity();
        _listCosts=Map.identity();
        emit(CostMonthsDataReceived());
      } else {
        emit(CostErrorState(responseJson["response"] as String));
      }
    }on Exception catch (e){
      log(e.toString());
      emit(CostErrorState("Ошибка"));
    }
  }

  Future<void> _getTypeCost(CostTypeGetEvent event,Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.get(Uri.parse("https://themlyakov.ru:8080/user/cost/type/all?month=${event.month.getAsInt()}"),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;
      if(response.statusCode==200){
        var costs=(responseJson["response"]["result"] as List<dynamic>).map((e) => TypeCost.fromJson(e)).toList();
        _typeCosts[event.month]=costs;
        _listCosts=Map.identity();
        emit(CostTypeDataReceived());
      }else{
        emit(CostErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(CostErrorState("Ошибка"));
    }
  }

  Future<void> _addCost(CostAddEvent event,Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/cost/add"
          "?vId=${event.cost.vehicle.id}"
          "&type=${event.cost.type.getAsParameter()}"
          "&date=${DateFormat("yyyy-MM-dd:HH:mm:ss").format(event.cost.date)}"
          "&value=${event.cost.value}"),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==201){
        emit(CostAddedState());
      }else{
        emit(CostErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(CostErrorState("Ошибка"));
    }
  }

  Future<void> _deleteCost(CostDeleteEvent event, Emitter<CostState> emit) async{
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.delete(Uri.parse("https://themlyakov.ru:8080/user/cost/delete/${event.cost.costId}"
          "?vId=${event.cost.vehicle.id}"
          "&type=${event.cost.type.getAsParameter()}"
          "&date=${DateFormat("yyyy-MM-dd:HH:mm:ss").format(event.cost.date)}"
          "&value=${event.cost.value}"),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        emit(CostDeletedState());
      }else{
        emit(CostErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(CostErrorState("Ошибка"));
    }
  }

  Map<Month, List<TypeCost>> get typeCosts => _typeCosts;

  Map<Month, List<Cost>> get listCosts => _listCosts;
}
