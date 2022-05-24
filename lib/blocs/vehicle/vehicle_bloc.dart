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
    on<GetVehiclesEvent>((event, emit) async => await _getVehiclesData(event,emit));
    on<AddVehicleEvent>((event, emit) async => await _addVehicleData(event, emit));
    on<EditVehicleEvent>((event, emit) async => await _editVehicleData(event, emit));
    on<DeleteVehicleEvent>((event, emit) async => await _deleteVehicleData(event, emit));
  }

  @override
  void onChange(Change<VehicleState> change) {
    super.onChange(change);
    log("VehicleBloc -> "+change.nextState.toString());
  }

  Future<void> _getVehiclesData(GetVehiclesEvent event,Emitter<VehicleState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.get(Uri.parse("https://themlyakov.ru:8080/user/vehicle/all"),
          headers: headers);
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

  Future<void> _addVehicleData(AddVehicleEvent event,Emitter<VehicleState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      if(event.vehicle.mark.isEmpty){
        emit(ValidationErrorState("Марка ТС не может быть пустой"));
        return;
      }
      else if(event.vehicle.mark.length>100){
        emit(ValidationErrorState("Длина марки ТС должна быть не более 100 символов"));
        return;
      }

      if(event.vehicle.model.isEmpty){
        emit(ValidationErrorState("Модель ТС не может быть пустой"));
        return;
      }
      else if(event.vehicle.model.length>100){
        emit(ValidationErrorState("Длина модели ТС должна быть не более 100 символов"));
        return;
      }

      if(event.vehicle.generation!=null&&event.vehicle.generation!.length>20){
        emit(ValidationErrorState("Длина поколения ТС должна быть не более 20 символов"));
        return;
      }

      if(event.vehicle.licensePlateNumber!=null&&event.vehicle.licensePlateNumber!.length>20){
        emit(ValidationErrorState("Длина регистрационного номера ТС должна быть не более 20 символов"));
        return;
      }


      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/vehicle/add"
          "?mark=${event.vehicle.mark}"
          "&model=${event.vehicle.model}"
          "&consumptionCity=${event.vehicle.consumptionCity}"
          "&consumptionMixed=${event.vehicle.consumptionMixed}"
          "&consumptionRoute=${event.vehicle.consumptionRoute}"
          "&fuelCapacity=${event.vehicle.fuelCapacity}"
          "&licensePlateNumber=${event.vehicle.licensePlateNumber}"
          "&generation=${event.vehicle.generation}"
      ),
          headers: headers);
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==201){
        emit(VehicleAddedState());
      }else{
        emit(VehicleErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(VehicleErrorState("Ошибка"));
    }
  }
  Future<void> _editVehicleData(EditVehicleEvent event,Emitter<VehicleState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      if(event.vehicle.mark.isEmpty){
        emit(ValidationErrorState("Марка ТС не может быть пустой"));
        return;
      }
      else if(event.vehicle.mark.length>100){
        emit(ValidationErrorState("Длина марки ТС должна быть не более 100 символов"));
        return;
      }

      if(event.vehicle.model.isEmpty){
        emit(ValidationErrorState("Модель ТС не может быть пустой"));
        return;
      }
      else if(event.vehicle.model.length>100){
        emit(ValidationErrorState("Длина модели ТС должна быть не более 100 символов"));
        return;
      }

      if(event.vehicle.generation!=null&&event.vehicle.generation!.length>20){
        emit(ValidationErrorState("Длина поколения ТС должна быть не более 20 символов"));
        return;
      }

      if(event.vehicle.licensePlateNumber!=null&&event.vehicle.licensePlateNumber!.length>20){
        emit(ValidationErrorState("Длина регистрационного номера ТС должна быть не более 20 символов"));
        return;
      }

      final response = await http.put(
          Uri.parse("https://themlyakov.ru:8080/user/vehicle/edit/${event.vehicle.id}"
              "?mark=${event.vehicle.mark}"
              "&model=${event.vehicle.model}"
              "&consumptionCity=${event.vehicle.consumptionCity}"
              "&consumptionMixed=${event.vehicle.consumptionMixed}"
              "&consumptionRoute=${event.vehicle.consumptionRoute}"
              "&fuelCapacity=${event.vehicle.fuelCapacity}"
              "&licensePlateNumber=${event.vehicle.licensePlateNumber}"
              "&generation=${event.vehicle.generation}"
          ),
          headers: headers);
      final responseJson = json.decode(
          utf8.decode(response.body.codeUnits)) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(VehicleEditedState());
      } else {
        emit(VehicleErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(VehicleErrorState("Ошибка"));
    }
  }
  Future<void> _deleteVehicleData(DeleteVehicleEvent event,Emitter<VehicleState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token = instance.getString("token")!;
    Map<String, String> headers = Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer " + token);
    try {
      final response = await http.delete(
          Uri.parse("https://themlyakov.ru:8080/user/vehicle/delete/${event.vehicle.id}"),
          headers: headers);
      final responseJson = json.decode(
          utf8.decode(response.body.codeUnits)) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        emit(VehicleDeletedState());
      } else {
        emit(VehicleErrorState(responseJson["response"] as String));
      }
    } on Exception {
      emit(VehicleErrorState("Ошибка"));
    }
  }
}
