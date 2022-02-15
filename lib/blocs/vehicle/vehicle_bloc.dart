import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/vehicle_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  List<Vehicle>? vehicles;

  VehicleBloc() : super(VehicleInitial()) {
    on<GetVehiclesEvent>((event, emit) async => await _getVehiclesData(emit));
  }

  @override
  void onChange(Change<VehicleState> change) {
    super.onChange(change);
    log("VehicleBloc -> "+change.nextState.toString());
  }

  Future<void> _getVehiclesData(Emitter<VehicleState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/vehicle/all"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        vehicles=(responseJson["response"] as List<dynamic>).map((e) => Vehicle.fromJson(e)).toList();
        emit(VehicleDataReceivedState());
      }else{
        emit(VehicleErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(VehicleErrorState("Ошибка"));
    }
  }
}
