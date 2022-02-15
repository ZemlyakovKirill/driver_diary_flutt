import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/cost_model.dart';
import 'package:driver_diary/models/type_cost_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'cost_event.dart';
part 'cost_state.dart';

class CostBloc extends Bloc<CostEvent, CostState> {
  double? total;
  List<Cost>? _listCosts;
  List<TypeCost>? _typeCosts;

  CostBloc() : super(CostInitial()) {
    on<CostListGetEvent>((event, emit) async => await _getListCost(emit));

    on<CostTypeGetEvent>((event, emit) async => await _getTypeCost(emit));
  }


  @override
  void onChange(Change<CostState> change) {
    super.onChange(change);
    log("CostBloc -> "+change.nextState.toString());
  }

  List<Cost>? get listCosts => _listCosts;

  Future<void> _getListCost(Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/cost/list/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        _listCosts=(responseJson["response"] as List<dynamic>).map((e) => Cost.fromJson(e)).toList();
        total=_listCosts!.fold(0, (previousValue, element) => previousValue!+element.value);
        emit(CostListDataReceived());
      }else{
        emit(CostListError(responseJson["response"] as String));
      }

  }

  Future<void> _getTypeCost(Emitter<CostState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/cost/type/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        _typeCosts=(responseJson["response"] as List<dynamic>).map((e) => TypeCost.fromJson(e)).toList();
        total=_typeCosts!.fold(0, (previousValue, element) => previousValue!+element.value);
        emit(CostTypeDataReceived());
      }else{
        emit(CostTypeError(responseJson["response"] as String));
      }
    }on Exception{
      emit(CostTypeError("Ошибка"));
    }
  }

  List<TypeCost>? get typeCosts => _typeCosts;
}
