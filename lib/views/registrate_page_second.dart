import 'package:driver_diary/blocs/registration_validation/registration_validation_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:driver_diary/views/vk_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../blocs/auth/auth_bloc.dart';
import 'google_page.dart';

class RegistratePageSecond extends StatelessWidget {
  String username;
  String password;

  RegistratePageSecond(this.username, this.password,{Key? key}):super(key: key);

  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: BlocConsumer<RegistrationValidationBloc,
              RegistrationValidationState>(
            listener: (context, state) {
              if (state is SecondStageErrorValidationState) {
                errorSnack(context, state.errorMessage);
                _lastNameController.text = "";
                _firstNameController.text = "";
                _emailController.text = "";
                _phoneController.text = "";
              } else if (state is SecondStageValidationSuccessState) {
                  BlocProvider.of<AuthBloc>(context).add(RegistrateUserEvent(
                    email: _emailController.text,
                    lastName: _lastNameController.text,
                    firstName: _firstNameController.text,
                    password: password,
                    username: username,
                    phone: _phoneController.text
                  ));
              }
            },
            builder: (context, state) {
              return Container(
                constraints: BoxConstraints.expand(),
                margin: EdgeInsets.symmetric(vertical: 20),
                child: KeyboardVisibilityBuilder(
                  builder: (context,isKeyboardVisible) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.8,
                          height: isKeyboardVisible?screenHeight*0.5:screenHeight * 0.7,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: !isKeyboardVisible,
                                child: Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(Icons.arrow_back,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        MyCustomIcons.app_icon,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: isKeyboardVisible?WrapAlignment.start:WrapAlignment.end,
                                  runSpacing: 10,
                                  children: [
                                    Text(
                                      "Личные данные",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Theme.of(context).canvasColor),
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: _lastNameController,
                                        maxLines: 1,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                            hintText: "Фамилия",
                                            counterText: "",
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      child: TextField(
                                        controller: _firstNameController,
                                        maxLines: 1,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          hintText: "Имя",
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _emailController,
                                        maxLines: 1,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          hintText: "Почта",
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).canvasColor,
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.phone,
                                        controller: _phoneController,
                                        maxLines: 1,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          hintText: "Телефон",
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius: BorderRadius.circular(15)),
                                      child: TextButton(
                                        onPressed: () => BlocProvider.of<
                                            RegistrationValidationBloc>(context)
                                          ..add(SecondStageValidationEvent(
                                              firstName: _firstNameController.text,
                                              lastName: _lastNameController.text,
                                              email: _emailController.text,
                                              phone: _phoneController.text)),
                                        child: Text("Зарегистрироваться",
                                            style: TextStyle(
                                                color: Theme.of(context)
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
                        ),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            spacing: 10,
                            direction: Axis.vertical,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/login"),
                                  child: Text("Авторизоваться",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color)),
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
                                        color: Theme.of(context).canvasColor),
                                    child: IconButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GooglePage(),
                                        ),
                                      ),
                                      icon: Icon(MyCustomIcons.google,
                                          color: Theme.of(context)
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
                                        color: Theme.of(context).canvasColor),
                                    child: IconButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VKPage(),
                                        ),
                                      ),
                                      icon: Icon(
                                        MyCustomIcons.vkontakte,
                                        color: Theme.of(context)
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
                    );
                  }
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
