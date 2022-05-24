import 'dart:developer';

import 'package:driver_diary/blocs/personal/personal_bloc.dart';
import 'package:driver_diary/blocs/vehicle/vehicle_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/views/add_vehicle_page.dart';
import 'package:driver_diary/views/edit_profile_page.dart';
import 'package:driver_diary/widgets/car_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../models/user_model.dart';
import '../widgets/stomp_listener.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _personalBloc = BlocProvider.of<PersonalBloc>(context);
    final _vehiclesBloc = BlocProvider.of<VehicleBloc>(context);
    if (_personalBloc.state is PersonalInitial) {
      _personalBloc.add(GetPersonalDataEvent());
    }
    if (_vehiclesBloc.state is VehicleInitial) {
      _vehiclesBloc.add(GetVehiclesEvent());
    }
    return StompListener(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: BlocConsumer<PersonalBloc, PersonalState>(
                    listener: (context, state) {
                      if (state is PersonalErrorState) {
                        errorSnack(context, state.errorMessage);
                      }
                      if (state is PersonalInitial) {
                        BlocProvider.of<PersonalBloc>(context)
                            .add(GetPersonalDataEvent());
                      }
                    },
                    builder: (context, state) {
                      if (_personalBloc.user != null) {
                        return Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10, 10, 10, 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.person_outline_sharp,
                                          color: Theme.of(context).textTheme.bodyText1!.color,
                                          size: 24,
                                        ),
                                        Text(
                                          _personalBloc.user!.username,
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Theme.of(context).textTheme.bodyText1!.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'ID:${_personalBloc.user!.id}',
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 13,
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Фамилия',
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          color: Theme.of(context).textTheme.bodyText1!.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5, 0, 0, 0),
                                          child: Text(
                                            _personalBloc.user!.lname,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context).textTheme.bodyText2!.color,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Имя',
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          color: Theme.of(context).textTheme.bodyText1!.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                5, 0, 0, 0),
                                        child: Text(
                                          _personalBloc.user!.fname,
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Theme.of(context).textTheme.bodyText2!.color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Почта',
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          color: Theme.of(context).textTheme.bodyText1!.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                5, 0, 0, 0),
                                        child: Text(
                                          _personalBloc.user!.email,
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Theme.of(context).textTheme.bodyText2!.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Телефон',
                                            style: TextStyle(
                                              fontFamily: 'Manrope',
                                              color: Theme.of(context).textTheme.bodyText1!.color,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(5, 0, 0, 0),
                                            child: Text(
                                              _personalBloc.user!.phone!,
                                              style: TextStyle(
                                                fontFamily: 'Manrope',
                                                color: Theme.of(context).textTheme.bodyText2!.color,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditProfilePage(bloc: _personalBloc,user:User.from(_personalBloc.user!)))),
                                            child:Icon(
                                                Icons.edit,
                                                size: 20,
                                                color:Theme.of(context).textTheme.bodyText1!.color
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10, 10, 10, 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SkeletonAvatar(
                                          style: SkeletonAvatarStyle(
                                              width: 30,
                                              height: 30,
                                              shape: BoxShape.circle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: SkeletonLine(
                                            style: SkeletonLineStyle(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                height: 10,
                                                width: 120),
                                          ),
                                        )
                                      ],
                                    ),
                                    SkeletonLine(
                                      style: SkeletonLineStyle(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          height: 10,
                                          width: 30),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        height: 10,
                                        width: 120),
                                  ),
                                ),
                                Expanded(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        height: 10,
                                        width: 120),
                                  ),
                                ),
                                Expanded(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        height: 10,
                                        width: 120),
                                  ),
                                ),
                                Expanded(
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        height: 10,
                                        width: 120),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  )),
              Expanded(
                child: BlocConsumer<VehicleBloc, VehicleState>(
                    listener: (context, state) {
                  if (state is VehicleErrorState) {
                    errorSnack(context, state.errorMessage);
                  }
                  if (state is VehicleInitial) {
                    BlocProvider.of<VehicleBloc>(context)
                        .add(GetVehiclesEvent());
                  }
                }, builder: (context, state) {
                  if (_vehiclesBloc.vehicles != null) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.drive_eta,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                size: 24,
                              ),
                              InkWell(
                                child: Icon(Icons.add,
                                    size: 30,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>AddVehiclePage(bloc:_vehiclesBloc))),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: _vehiclesBloc.vehicles!
                                  .map((e) => CarPanel(
                                          vehicle: e,)
                                      )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                    shape: BoxShape.circle,
                                    height: 30,
                                    width: 30),
                              ),
                              SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                    shape: BoxShape.circle,
                                    height: 30,
                                    width: 30),
                              )
                            ],
                          ),
                          Expanded(
                            child: SkeletonListView(
                                scrollable: true,
                                itemCount: 15,
                                itemBuilder: (context, _) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SkeletonLine(
                                        style: SkeletonLineStyle(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          width: double.infinity,
                                          height: 20,
                                        ),
                                      ),
                                    )),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
