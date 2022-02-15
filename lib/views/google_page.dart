import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/widgets/bars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GooglePage extends StatelessWidget {
  const GooglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBars(appBarValue: 10,),
      body: WebView(
        userAgent: "Chrome/56.0.0.0 Mobile",
        initialUrl: "https://themlyakov.ru:8080/google/auth",
        zoomEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) async {
          if (RegExp(
                  r'^(\bhttps:\/\/themlyakov\.ru:8080\b)(.*\baccessing\b)(.*\bcode\b)')
              .hasMatch(request.url)) {
            print(request.url);
            BlocProvider.of<AuthBloc>(context).add(LoginViaGoogleEvent(request.url));
            BlocProvider.of<RedirectBloc>(context).add(RedirectToLoginPageEvent());
            return NavigationDecision.prevent;
          } else if (RegExp(
                  r'^(\bhttps:\/\/themlyakov\.ru:8080\b)(.*\baccessing\b)(.*\berror\b)')
              .hasMatch(request.url)) {
            BlocProvider.of<AuthBloc>(context).add(ErrorGoogleAuthEvent("Пользователь отказался или возникла ошибка"));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
