import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'personal_event.dart';
part 'personal_state.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  User? user;

  PersonalBloc() : super(PersonalInitial()) {
    on<GetPersonalDataEvent>((event, emit)async => await _getPersonalData(emit));
  }


  @override
  void onChange(Change<PersonalState> change) {
    super.onChange(change);
    log("PersonalBloc -> "+change.nextState.toString());
  }

  Future<void> _getPersonalData(Emitter<PersonalState> emit) async {
    final instance = await SharedPreferences.getInstance();
    String token=instance.getString("token")!;
    Map<String,String> headers=Map.identity();
    headers.putIfAbsent("Authorization", () => "Bearer "+token);
    try{
      final response = await http.post(Uri.parse("https://themlyakov.ru:8080/user/personal"),
          headers: headers, encoding: Encoding.getByName("UTF-8"));
      final responseJson=json.decode(utf8.decode(response.body.codeUnits)) as Map<String,dynamic>;

      if(response.statusCode==200){
        user=User.fromJson(responseJson["response"]);
        emit(PersonalDataReceivedState());
      }else{
        emit(PersonalErrorState(responseJson["response"] as String));
      }
    }on Exception{
      emit(PersonalErrorState("Ошибка"));
    }

  }
}
