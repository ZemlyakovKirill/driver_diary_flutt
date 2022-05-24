import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/widgets/bars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'login_page.dart';

class VKPage extends StatefulWidget {
  VKPage({Key? key}):super(key:key);
  @override
  State<StatefulWidget> createState() => _VKPageState();
}

class _VKPageState extends State<VKPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBars(appBarValue: 20,),
      body: WebView(
        userAgent:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36",
        initialUrl: "https://themlyakov.ru:8080/vk/auth",
        zoomEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) async {
          if (RegExp(
                  r'^(\bhttps:\/\/themlyakov\.ru:8080\b)(.*\baccessing\b)(.*\bcode\b)')
              .hasMatch(request.url)) {
            BlocProvider.of<AuthBloc>(context).add(LoginViaVKEvent(request.url));
            BlocProvider.of<RedirectBloc>(context).add(RedirectToLoginPageEvent());
            return NavigationDecision.prevent;
          } else if (RegExp(
                  r'^(\bhttps:\/\/themlyakov\.ru:8080\b)(.*\baccessing\b)(.*\berror\b)')
              .hasMatch(request.url)) {
            BlocProvider.of<AuthBloc>(context).add(ErrorVKAuthEvent("Пользователь отказался или возникла ошибка"));
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
