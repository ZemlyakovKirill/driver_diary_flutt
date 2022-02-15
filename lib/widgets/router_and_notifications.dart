import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/utils/error_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/views/google_page.dart';
import 'package:driver_diary/views/loading_page.dart';
import 'package:driver_diary/views/login_page.dart';
import 'package:driver_diary/views/main.dart';
import 'package:driver_diary/views/registrate_page_first.dart';
import 'package:driver_diary/views/registrate_page_second.dart';
import 'package:driver_diary/views/vk_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocRouter extends StatelessWidget {
  const BlocRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorAuthorizingState) {
          errorSnack(context, state.errorMessage);
        } else if (state is ErrorCreatingState) {
          errorSnack(context, state.errorMessage);
        } else if (state is ErrorGoogleAuthState) {
          errorSnack(context, state.errorMessage);
        } else if (state is ErrorVKAuthState) {
          errorSnack(context, state.errorMessage);
        }
        else if(state is UnAuthorizedState){
          BlocProvider.of<StompBloc>(context).add(CloseConnectionToStompEvent());
        }
        else if (state is AuthorizedState) {
          BlocProvider.of<StompBloc>(context)
              .add(InitializeStompClientEvent());
        }
      },
      builder: (context, authState) {
        return BlocListener<StompBloc, StompState>(
            listener: (context, state) {
              if (state is NotificationDataReceived) {
                notificationSnack(context, state.body);
              }
            }, child: BlocBuilder<RedirectBloc, RedirectState>(
          builder: (context, redirectState) {
            if (authState is UnAuthorizedState || authState is ErrorFlag) {
              if (redirectState is RedirectToVKState) {
                return VKPage();
              } else if (redirectState is RedirectToGoogleState) {
                return GooglePage();
              } else if (redirectState is RedirectToLoginState) {
                return LoginPage();
              } else if (redirectState
              is RedirectToRegistrationFirstState) {
                return RegistratePageFirst();
              } else if (redirectState
              is RedirectToRegistrationSecondState) {
                return RegistratePageSecond(
                    redirectState.username, redirectState.password);
              }
              return LoginPage();
            } else if (authState is AuthorizedState) {
              return HomePage();
            } else if (authState is ErrorGoogleAuthState ||
                authState is ErrorVKAuthState) {
              return LoginPage();
            } else {
              return LoadingPage();
            }
          },
        ));
      },
    );
  }
}
