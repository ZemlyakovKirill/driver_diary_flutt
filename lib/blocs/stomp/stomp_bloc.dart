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
import 'package:stomp_dart_client/stomp_handler.dart';

part 'stomp_event.dart';

part 'stomp_state.dart';

class StompBloc extends Bloc<StompEvent, StompState> {
  static const PERSONAL_USER_INFORMATION_URI =
      "https://themlyakov.ru:8080/user/personal";
  static const WEB_SOCKET_CONNECTON_URI = "https://themlyakov.ru:8080/ws";
  static const TOPIC_NOTIFICATION_DEST = '/topic/notifications';
  static const TEST_TOKEN_MESSAGE_DEST = "/app/token/test";
  static const TOPIC_NEWS_URI = '/topic/news';

  StompClient? client;
  Timer? _tokenTimer;
  int _reconnectAttempts = 0;

  StompUnsubscribe? _unsNotifications;
  StompUnsubscribe? _unsTokenTest;
  StompUnsubscribe? _unsNote;
  StompUnsubscribe? _unsCost;
  StompUnsubscribe? _unsNews;
  StompUnsubscribe? _unsVehicle;
  StompUnsubscribe? _unsPersonal;
  StompUnsubscribe? _unsMarkers;

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
    on<ConnectedToServerEvent>((event, emit) {
      emit(ConnectedState());
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

    on<MarkersDataReceivedEvent>((event, emit) {
      emit(MarkersDataReceivedState(event.body));
    });

    on<NotesDataReceivedEvent>((event, emit) {
      emit(NotesDataReceivedState(event.body));
    });

    on<ErrorFrameEvent>(
        (event, emit) => emit(ErrorFrameState(event.errorMessage)));

    on<TokenStateReceivedEvent>((event, emit) {
      if (event.status != 200) {
        emit(DisconnectedState());
      }
    });
    on<ErrorConnectingToServer>((event, emit) {
      emit(ErrorConnectingToServerState());
    });

    on<ErrorUsernameCheckingEvent>(
        (event, emit) => emit(ErrorUsernameCheckingState(event.errorMessage)));
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
      final response = await http.get(Uri.parse(PERSONAL_USER_INFORMATION_URI),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        String username =
            json.decode(utf8.decode(response.body.codeUnits))["response"]
                ["username"];
        return StompClient(
            config: StompConfig.SockJS(
          // onDebugMessage: (msg) => log(msg),
          heartbeatIncoming: Duration(milliseconds: 10),
          heartbeatOutgoing: Duration(milliseconds: 10),
          url: WEB_SOCKET_CONNECTON_URI,
          stompConnectHeaders: {'Authorization': token},
          webSocketConnectHeaders: {'Authorization': token},
          onWebSocketError: (_) {
            add(ErrorConnectingToServer());
          },
          onStompError: (p0) {
            log(p0.body??"empty");
            add(ErrorFrameEvent(p0.toString()));
          },
          beforeConnect: () async {
            log('Waiting to connect...');
          },
          onDisconnect: (_) {
            add(CloseConnectionToStompEvent());
          },
          reconnectDelay: Duration(milliseconds: 500),
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
    add(ConnectedToServerEvent());
    String url = client!.config.url;
    String sessionId =
        RegExp(r'.*\/([^\/]*)\/websocket$').firstMatch(url)!.group(1)!;
    _unsNotifications = client!.subscribe(
        destination: TOPIC_NOTIFICATION_DEST,
        headers: {"Authorization": token},
        callback: (frame) {
          add(NotificationDataReceivedEvent(frame.body!));
        });

    _unsTokenTest = client!.subscribe(
      destination: '/session/$sessionId/token/test',
      callback: (p0) {
        log("valid");
        add(TokenStateReceivedEvent(
            int.parse(p0.headers["status"].toString())));
      },
    );
    _unsNews = client!.subscribe(
        destination: TOPIC_NEWS_URI,
        headers: {"Authorization": token},
        callback: (frame) {
          add(NewsDataReceivedEvent(frame.body!));
        });

    _unsMarkers = client!.subscribe(
        destination: "/user/$username/mark",
        headers: {"Authorization": token},
        callback: (frame) {
          add(MarkersDataReceivedEvent(frame.body!));
        });

    _unsPersonal = client!.subscribe(
        destination: '/user/$username/personal',
        headers: {"Authorization": token},
        callback: (frame) {
          add(UserDataReceivedEvent(frame.body!));
        });

    _unsVehicle = client!.subscribe(
        destination: '/user/$username/vehicle',
        headers: {"Authorization": token},
        callback: (frame) {
          add(VehiclesDataReceivedEvent(frame.body!));
        });

    _unsCost = client!.subscribe(
        destination: '/user/$username/cost',
        headers: {"Authorization": token},
        callback: (frame) {
          add(CostsDataReceivedEvent(frame.body!));
        });

    _unsNote = client!.subscribe(
        destination: '/user/$username/note',
        headers: {"Authorization": token},
        callback: (frame) {
          add(NotesDataReceivedEvent(frame.body!));
        });
    _reconnectAttempts = 0;
  }

  Future<void> _unsubscribeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _header = {"Authorization": prefs.getString('token')!};
    _unsNotifications!(unsubscribeHeaders: _header);
    _unsCost!(unsubscribeHeaders: _header);
    _unsNews!(unsubscribeHeaders: _header);
    _unsNote!(unsubscribeHeaders: _header);
    _unsPersonal!(unsubscribeHeaders: _header);
    _unsVehicle!(unsubscribeHeaders: _header);
    _unsTokenTest!(unsubscribeHeaders: _header);
  }
}
