import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

part 'stomp_event.dart';

part 'stomp_state.dart';

class StompBloc extends Bloc<StompEvent, StompState> {
  static const PERSONAL_USER_INFORMATION_URI = "https://themlyakov.ru:8080/user/personal";
  static const WEB_SOCKET_CONNECTON_URI = "https://themlyakov.ru:8080/ws";
  static const TOPIC_NOTIFICATION_DEST = '/topic/notifications';
  static const TEST_TOKEN_MESSAGE_DEST = "/app/token/test";
  static const TOPIC_NEWS_URI = '/topic/news';

  StompClient? client;
  Timer? _tokenTimer;

  StompBloc() : super(StompInitial()) {
    on<InitializeStompClientEvent>((event, emit) async {
      final instance = await SharedPreferences.getInstance();
      if (instance.containsKey('token')) {
        client = await _connect(instance.getString('token')!, emit);
        if (client != null) {
          log("Client activating");
          client!.activate();
        }
      } else {
        emit(ErrorTokenReceivingState("Отсутсвует токен доступа"));
      }
    });

    on<NotificationDataReceivedEvent>((event, emit) {
      emit(NotificationDataReceived(event.body));
    });
    on<VehiclesDataReceivedEvent>((event, emit) {
      emit(VehiclesDataReceivedState(event.body));
    });
    on<CostsDataReceivedEvent>((event, emit) {
      emit(CostsDataReceivedState(event.body));
    });

    on<UserDataReceivedEvent>((event, emit) {
      emit(UserDataReceivedState(event.body));
    });

    on<NewsDataReceivedEvent>((event, emit) {
      emit(NewsDataReceivedState(event.body));
    });

    on<NotesDataReceivedEvent>((event, emit) {
      emit(NotesDataReceivedState(event.body));
    });

    on<TokenStateReceivedEvent>((event, emit) {
      if (event.status != 200) {
        emit(DisconnectedState());
      }
    });

    on<CloseConnectionToStompEvent>((event, emit) {
      if (client != null) {
        client!.deactivate();
      }
      if (_tokenTimer != null) {
        _tokenTimer!.cancel();
      }
      emit(DisconnectedState());
    });
  }

  Future<StompClient?> _connect(String token, Emitter<StompState> emit) async {
    try {
      final response = await http.post(
          Uri.parse(PERSONAL_USER_INFORMATION_URI),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        String username =
        json.decode(utf8.decode(response.body.codeUnits))["response"]
        ["username"];
        return StompClient(
            config: StompConfig.SockJS(
              url: WEB_SOCKET_CONNECTON_URI,
              stompConnectHeaders: {'Authorization': token},
              webSocketConnectHeaders: {'Authorization': token},
              onWebSocketError: (_) =>
                  emit(ErrorFrameState("Ошибка вебсокета")),
              onStompError: (p0) => emit(ErrorFrameState(p0.body ?? "")),
              beforeConnect: () async {
                log('Waiting to connect...');
                await Future.delayed(Duration(milliseconds: 200));
                log('Connecting...');
              },
              onConnect: (frame) => _onConnect(frame, token, username, emit),
            ));
      }
    } on Exception catch (e) {
      emit(ErrorUsernameCheckingState(e.toString()));
    }
    emit(ErrorUsernameCheckingState("Ошибка"));
  }

  @override
  void onChange(Change<StompState> change) {
    super.onChange(change);
    log("StompBloc ->" + change.nextState.toString());
  }

  void _onConnect(StompFrame frame, String token, String username,
      Emitter<StompState> emit) {
    log("Connected");
    String url = client!.config.url;
    String sessionId =
    RegExp(r'.*\/([^\/]*)\/websocket$').firstMatch(url)!.group(1)!;
    _tokenTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      client!.send(
          destination: TEST_TOKEN_MESSAGE_DEST, headers: {"Authorization": token});
    });
    client!.subscribe(
        destination: TOPIC_NOTIFICATION_DEST,
        headers: {"Authorization": token},
        callback: (frame) {
          add(NotificationDataReceivedEvent(frame.body!));
        });

    client!.subscribe(
      destination: '/session/$sessionId/token/test',
      callback: (p0) {
        add(TokenStateReceivedEvent(
            int.parse(p0.headers["status"].toString())));
      },
    );

    client!.subscribe(
        destination:TOPIC_NEWS_URI,
        headers: {"Authorization": token},
        callback: (frame) {
          add(NewsDataReceivedEvent(frame.body!));
        });

    client!.subscribe(
        destination: '/user/$username/personal',
        headers: {"Authorization": token},
        callback: (frame) {
          add(UserDataReceivedEvent(frame.body!));
        });

    client!.subscribe(
        destination: '/user/$username/vehicle',
        headers: {"Authorization": token},
        callback: (frame) {
          add(VehiclesDataReceivedEvent(frame.body!));
        });

    client!.subscribe(
        destination: '/user/$username/cost',
        headers: {"Authorization": token},
        callback: (frame) {
          add(CostsDataReceivedEvent(frame.body!));
        });

    client!.subscribe(
        destination: '/user/$username/note',
        headers: {"Authorization": token},
        callback: (frame) {
          add(NotesDataReceivedEvent(frame.body!));
        });
  }
}
