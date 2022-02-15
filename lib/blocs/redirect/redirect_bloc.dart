import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'redirect_event.dart';
part 'redirect_state.dart';

class RedirectBloc extends Bloc<RedirectEvent, RedirectState> {
  RedirectBloc() : super(RedirectInitial()) {
    on<RedirectToLoginPageEvent>((event, emit) {
      emit(RedirectToLoginState());
    });
    on<RedirectToFirstRegistratePageEvent>((event, emit) {
      emit(RedirectToRegistrationFirstState());
    });
    on<RedirectToSecondRegistratePageEvent>((event, emit) {
      emit(RedirectToRegistrationSecondState(username: event.username,password: event.password));
    });
    on<RedirectToGooglePageEvent>((event, emit) {
      emit(RedirectToGoogleState());
    });
    on<RedirectToVKPageEvent>((event, emit) {
      emit(RedirectToVKState());
    });
  }

  @override
  void onChange(Change<RedirectState> change) {
    super.onChange(change);
    log('RedirectBloc -> '+change.nextState.toString());
  }
}
