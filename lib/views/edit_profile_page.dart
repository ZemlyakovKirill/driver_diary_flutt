import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/personal/personal_bloc.dart';
import '../models/user_model.dart';
import '../utils/msg_utils.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, required this.user, required this.bloc})
      : super(key: key);
  User user;
  PersonalBloc bloc;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _surnameController.text = widget.user.lname;
    _nameController.text = widget.user.fname;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Редактирование профиля",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        ),
        body: BlocListener<PersonalBloc, PersonalState>(
          listener: (context, state) {
            if (state is ValidationErrorState) {
              errorSnack(context, state.errorMessage);
            }
            if (state is PersonalErrorState) {
              errorSnack(context, state.errorMessage);
            }
            if (state is PersonalEditedState) {
              infoSnack(context, "Личные данные отредактированы");
              Navigator.of(context).pop();
            }
          },
          bloc: widget.bloc,
          child: Container(
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: LayoutBuilder(builder: (context, constr) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constr.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              enabled:
                                  !(widget.user.isVk || widget.user.isGoogle),
                              controller: _usernameController,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "Никнейм",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _emailController,
                              enabled:
                                  !(widget.user.isVk || widget.user.isGoogle),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "Почта",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _surnameController,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "Фамилия",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Имя",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _phoneController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Телефон",
                                hintStyle:  TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () => _editProfile(),
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).canvasColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              child: Text("Редактировать",
                                  style: TextStyle(
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color)))
                        ],
                      ),
                    ),
                  ),
                );
              })),
        ));
  }

  void _editProfile() {
    User user = User(
      username: _usernameController.text,
      email: _emailController.text,
      fname: _nameController.text,
      id: widget.user.id,
      isGoogle: widget.user.isGoogle,
      isVk: widget.user.isVk,
      lname: _surnameController.text,
      phone: _phoneController.text,
    );
    widget.bloc.add(EditPersonalDataEvent(user));
  }
}
