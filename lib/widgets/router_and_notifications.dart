import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/views/error_no_connection.dart';
import 'package:driver_diary/views/google_page.dart';
import 'package:driver_diary/views/loading_page.dart';
import 'package:driver_diary/views/login_page.dart';
import 'package:driver_diary/views/main.dart';
import 'package:driver_diary/views/registrate_page_first.dart';
import 'package:driver_diary/views/registrate_page_second.dart';
import 'package:driver_diary/views/vk_page.dart';
import 'package:driver_diary/widgets/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


typedef void setStateCustom();

class BlocRouter extends StatefulWidget {
  BlocRouter({Key? key}) : super(key: key);

  @override
  State<BlocRouter> createState() => _BlocRouterState();
}

class _BlocRouterState extends State<BlocRouter> {
  Widget _currentPage=LoadingPage();

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    final _stompBloc = BlocProvider.of<StompBloc>(context);
    final _redirectBloc = BlocProvider.of<RedirectBloc>(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ErrorAuthorizingState) {
              errorSnack(context, state.errorMessage);
              _redirectBloc.add(RedirectToErrorLoginPageEvent());
            } else if (state is ErrorCreatingState) {
              errorSnack(context, state.errorMessage);
              _redirectBloc.add(RedirectToErrorLoginPageEvent());
            } else if (state is ErrorGoogleAuthState) {
              errorSnack(context, state.errorMessage);
              _redirectBloc.add(RedirectToErrorLoginPageEvent());
            } else if (state is ErrorVKAuthState) {
              errorSnack(context, state.errorMessage);
              _redirectBloc.add(RedirectToErrorLoginPageEvent());
            } else if (state is UnAuthorizedState) {
              _stompBloc.add(CloseConnectionToStompEvent());
              _redirectBloc.add(RedirectToErrorLoginPageEvent());
            } else if (state is AuthorizedState) {
              _redirectBloc.add(RedirectToHomePageEvent());
              _stompBloc.add(InitializeStompClientEvent());
            }
          },
        ),
        BlocListener<StompBloc, StompState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is NotificationDataReceived) {
              notificationSnack(context, state.body);
            } else if (state is ErrorConnectingToServerState) {
              _redirectBloc.add(RedirectToNoConnectionPageEvent());
            } else if (state is ConnectedState) {
              _redirectBloc.add(RedirectToHomePageEvent());
            }
          },
        ),
      ], child: BlocBuilder<RedirectBloc,RedirectState>(
      buildWhen: (previous, current) => previous!=current,
        builder: (context,state) {
          if (state is RedirectToHomePageState) {
            return AnimatedAppearance(child: HomePage());
          } else if (state is RedirectToNoConnectionPageState) {
            return AnimatedAppearance(child: NoConnectionPage());
          }else if (state is RedirectToErrorLoginState) {
            return AnimatedAppearance(child: LoginPage());
          }
          else if (state is RedirectToLoginState) {
            return AnimatedAppearance(child: LoginPage());
          } else if (state is RedirectToRegistrationFirstState) {
            return AnimatedAppearance(child: RegistratePageFirst());
          } else if (state is RedirectToRegistrationSecondState) {
            return AnimatedAppearance(child: RegistratePageSecond(state.username, state.password));
          } else if (state is RedirectToVKState) {
            return AnimatedAppearance(child: VKPage());
          } else if (state is RedirectToGoogleState) {
            return AnimatedAppearance(child: GooglePage());
          } else {
            return LoadingPage();
          }
        }
    ),);
  }

  void _changePage(Widget page) {
    if (_currentPage!=page) {
      _currentPage=page;
    }
  }
}
