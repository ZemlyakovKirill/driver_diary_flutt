import 'package:driver_diary/blocs/login_validation/login_validation_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../blocs/auth/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}):super(key: key);
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: SafeArea(
          child: BlocConsumer<LoginValidationBloc, LoginValidationState>(
            listener: (context, state) {
              if (state is ValidationErrorState) {
                errorSnack(context, state.errorMessage);
                _usernameController.text = "";
                _passwordController.text = "";
              } else if (state is ValidationSuccessState) {
                BlocProvider.of<AuthBloc>(context).add(
                    GetAndSaveTokenEvent(username: _usernameController.text,
                        password: _passwordController.text)
                );
              }
            },
            builder: (context, state) {
              return Container(
                constraints: BoxConstraints.expand(),
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                          return Container(
                            width: screenWidth * 0.8,
                            height: isKeyboardVisible
                                ? screenHeight * 0.4
                                : screenHeight * 0.7,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: !isKeyboardVisible,
                                  child: Icon(
                                    MyCustomIcons.app_icon,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    size: 50,
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: isKeyboardVisible
                                        ? WrapAlignment.start
                                        : WrapAlignment.end,
                                    runSpacing: 10,
                                    children: [
                                      Text(
                                        "Авторизация",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                15),
                                            color: Theme
                                                .of(context)
                                                .canvasColor),
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          controller: _usernameController,
                                          maxLines: 1,
                                          maxLength: 50,
                                          decoration: InputDecoration(
                                              hintText: "Никнейм",
                                              counterText: "",
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          color: Theme
                                              .of(context)
                                              .canvasColor,
                                        ),
                                        child: TextField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          maxLines: 1,
                                          maxLength: 255,
                                          decoration: InputDecoration(
                                            hintText: "Пароль",
                                            counterText: "",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .canvasColor,
                                            borderRadius: BorderRadius.circular(
                                                15)),
                                        child: TextButton(
                                          onPressed: () =>
                                          BlocProvider.of<LoginValidationBloc>(
                                              context)
                                            ..add(ValidateEvent(
                                                username: _usernameController
                                                    .text,
                                                password: _passwordController
                                                    .text)),
                                          child: Text("Авторизоваться",
                                              style: TextStyle(
                                                  color: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 10,
                        direction: Axis.vertical,
                        children: [
                          Hero(
                            tag: "Registration First Page",
                            child: Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .canvasColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: TextButton(
                                onPressed: () =>
                                    BlocProvider.of<RedirectBloc>(context).add(
                                        RedirectToFirstRegistratePageEvent()),
                                child: Text("Зарегистрироваться",
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color)),
                              ),
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 10,
                            direction: Axis.horizontal,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme
                                        .of(context)
                                        .canvasColor),
                                child: IconButton(
                                  onPressed: () =>
                                      BlocProvider.of<RedirectBloc>(context)
                                          .add(RedirectToGooglePageEvent()),
                                  icon: Icon(MyCustomIcons.google,
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                                  iconSize: 30,
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme
                                        .of(context)
                                        .canvasColor),
                                child: IconButton(
                                  onPressed: () =>
                                      BlocProvider.of<RedirectBloc>(context)
                                          .add(RedirectToVKPageEvent()),
                                  icon: Icon(
                                    MyCustomIcons.vkontakte,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  iconSize: 30,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
