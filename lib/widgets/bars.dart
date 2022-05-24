import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/note_indicator/note_indicator_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:driver_diary/views/add_note_page.dart';
import 'package:driver_diary/views/cost_filter.dart';
import 'package:driver_diary/views/map_filter.dart';
import 'package:driver_diary/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cost/cost_bloc.dart';
import '../blocs/map/map_bloc.dart';
import '../blocs/news/news_bloc.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/personal/personal_bloc.dart';
import '../blocs/stomp/stomp_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../views/add_cost_page.dart';
import '../views/news_filter.dart';
import '../views/note_filter.dart';

class CustomBars extends StatelessWidget with PreferredSizeWidget {
  final int appBarValue;

  const CustomBars({Key? key, required this.appBarValue}) : super(key: key);

  @override
  Size get preferredSize =>
      Size(double.infinity, appBarValue != 2 ? 50 : 90);

  Widget build(BuildContext context) {
    var _stompBloc=BlocProvider.of<StompBloc>(context);


    switch (appBarValue) {
      case 0:
        ValueNotifier<bool> isCompleted=ValueNotifier<bool>(true);
        var _mapBloc=BlocProvider.of<MapBloc>(context);
        return MultiBlocListener(
          listeners: [
            BlocListener<StompBloc, StompState>(
              bloc: _stompBloc,
              listener: (context, state) {
                if (state is MarkersDataReceivedState) {
                  isCompleted.value = false;
                }
              },
            ),
            BlocListener<MapBloc, MapState>(
              bloc: _mapBloc,
              listener: (context, state) {
                if (state is MarkersReceivedState) {
                  isCompleted.value = true;
                }
              },
            ),
          ],
          child: AppBar(
              shadowColor: Colors.transparent,
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              leading: InkWell(
                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MapFilter(
                      mapBloc: _mapBloc,
                    ))),
                child: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              title: Text(
                "Карты",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
              actions: [
                ValueListenableBuilder<bool>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomAnimatedProgressIndicator(
                        size: 24,
                        isCompleted: value,
                        plug: Icon(MyCustomIcons.app_icon,
                            color: Theme.of(context).textTheme.bodyText1!.color!),
                        color: Theme.of(context).textTheme.bodyText1!.color!),
                  ),
                  valueListenable: isCompleted,
                ),
              ]),
        );
      case 1:
        ValueNotifier<bool> isCompleted=ValueNotifier<bool>(true);
        var _costBloc=BlocProvider.of<CostBloc>(context);
        var _vehiclesBloc=BlocProvider.of<VehicleBloc>(context);
        return MultiBlocListener(
          listeners: [
            BlocListener<StompBloc, StompState>(
              bloc: _stompBloc,
              listener: (context, state) {
                if (state is CostsDataReceivedState) {
                  isCompleted.value = false;
                }
              },
            ),
            BlocListener<CostBloc, CostState>(
              bloc: _costBloc,
              listener: (context, state) {
                if (state is CostMonthsDataReceived) {
                  isCompleted.value = true;
                }
              },
            ),
          ],
          child: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            actions: [
              ValueListenableBuilder<bool>(
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomAnimatedProgressIndicator(
                      size: 24,
                      isCompleted: value,
                      plug: InkWell(
                          child: Icon(Icons.add,
                              color: Theme.of(context).textTheme.bodyText1!.color),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AddCostPage(
                                costBloc: _costBloc,
                                vehicleBloc: _vehiclesBloc,
                              )))),
                      color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
                valueListenable: isCompleted,
              ),
            ],
            leading: InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CostFilter(
                    costBloc: BlocProvider.of<CostBloc>(context),
                  ))),
              child: Icon(
                Icons.filter_list,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            title: Text(
              "Расходы",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
            ),
          ),
        );
      case 2:
        final _indicBloc = BlocProvider.of<NoteIndicatorBloc>(context)
          ..add(NoteTypeChangedEvent(0));
        var _noteBloc=BlocProvider.of<NoteBloc>(context);
        var _vehiclesBloc=BlocProvider.of<VehicleBloc>(context);
        ValueNotifier<bool> isCompleted=ValueNotifier<bool>(true);
        return BlocBuilder<NoteIndicatorBloc, NoteIndicatorState>(
          builder: (context, state) {
            if (state is NoteIndicatorChangedState) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<StompBloc, StompState>(
                    bloc: _stompBloc,
                    listener: (context, state) {
                      if (state is NotesDataReceivedState) {
                        isCompleted.value = false;
                      }
                    },
                  ),
                  BlocListener<NoteBloc, NoteState>(
                    bloc: _noteBloc,
                    listener: (context, state) {
                      if (state is NotesOverduedReceivedState ||
                          state is NotesCompletedReceivedState ||
                          state is NotesUncompletedReceivedState
                      ) {
                        isCompleted.value = true;
                      }
                    },
                  ),
                ],
                child: AppBar(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: [
                    ValueListenableBuilder<bool>(
                      builder: (context, value, child) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CustomAnimatedProgressIndicator(
                            size: 24,
                            isCompleted: value,
                            plug: InkWell(
                                child: Icon(Icons.add,
                                    color: Theme.of(context).textTheme.bodyText1!.color),
                                onTap: () =>
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => AddNotePage(
                                          bloc: _noteBloc,
                                          vehicleBloc:_vehiclesBloc,
                                        )))),
                            color: Theme.of(context).textTheme.bodyText1!.color!),
                      ),
                      valueListenable: isCompleted,
                    ),
                  ],
                  leading: InkWell(
                    onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NoteFilter(
                          noteBloc: BlocProvider.of<NoteBloc>(context),
                        ))),
                    child: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                  title: Text(
                    "Заметки",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                  bottom: TabBar(
                    onTap: (value) => _indicBloc.add(NoteTypeChangedEvent(value)),
                    indicatorColor: state.indicatorColor,
                    tabs: [
                      Tab(
                          icon: Icon(Icons.hourglass_empty_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color)),
                      Tab(
                          icon: Icon(Icons.check_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color)),
                      Tab(
                          icon: Icon(Icons.clear_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color)),
                    ],
                  ),
                ),
              );
            }
            return AppBar(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).primaryColor,
              leading: Icon(
                Icons.filter_list,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
              title: Text(
                "Заметки",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
            );
          },
        );
      case 3:
        ValueNotifier<bool> isCompleted=ValueNotifier<bool>(true);
        var _newsBloc=BlocProvider.of<NewsBloc>(context);
        return MultiBlocListener(
          listeners: [
            BlocListener<StompBloc, StompState>(
              bloc: _stompBloc,
              listener: (context, state) {
                if (state is NewsDataReceivedState) {
                  isCompleted.value = false;
                }
              },
            ),
            BlocListener<NewsBloc, NewsState>(
              bloc: _newsBloc,
              listener: (context, state) {
                if (state is NewsReceivedState) {
                  isCompleted.value = true;
                }
              },
            ),
          ],
          child: AppBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor,
            leading: InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => NewsFilter(
                    newsBloc: _newsBloc,
                  ))),
              child: Icon(
                Icons.filter_list,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            title: Text(
              "Новости",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            actions: [
              ValueListenableBuilder<bool>(
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomAnimatedProgressIndicator(
                      size: 24,
                      isCompleted: value,
                      plug: Icon(MyCustomIcons.app_icon,
                          color: Theme.of(context).textTheme.bodyText1!.color!),
                      color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
                valueListenable: isCompleted,
              ),
            ],
          ),
        );
      case 4:
        ValueNotifier<bool> isCompleted=ValueNotifier<bool>(true);
        var _personalBloc=BlocProvider.of<PersonalBloc>(context);
        var _vehiclesBloc=BlocProvider.of<VehicleBloc>(context);
        return MultiBlocListener(
          listeners: [
            BlocListener<StompBloc, StompState>(
              bloc: _stompBloc,
              listener: (context, state) {
                if (state is UserDataReceivedState ||
                    state is VehicleDataReceivedState
                ) {
                  isCompleted.value = false;
                }
              },
            ),
            BlocListener<PersonalBloc, PersonalState>(
              bloc:_personalBloc,
              listener: (context, state) {
                if (state is PersonalDataReceivedState) {
                  isCompleted.value = true;
                }
              },
            ),
            BlocListener<VehicleBloc, VehicleState>(
              bloc: _vehiclesBloc,
              listener: (context, state) {
                if (state is VehicleDataReceivedState) {
                  isCompleted.value = true;
                }
              },
            ),
          ],
          child: AppBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.exit_to_app_rounded),
              onPressed: () =>
                  BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            title: Text(
              "Профиль",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            actions: [
              ValueListenableBuilder<bool>(
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomAnimatedProgressIndicator(
                      size: 24,
                      isCompleted: value,
                      plug: Icon(MyCustomIcons.app_icon,
                          color: Theme.of(context).textTheme.bodyText1!.color!),
                      color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
                valueListenable: isCompleted,
              ),
            ],
          ),
        );
      case 10:
        return AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => BlocProvider.of<RedirectBloc>(context)
                .add(RedirectToLoginPageEvent()),
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Авторизация через Google",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        );
      case 20:
        return AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => BlocProvider.of<RedirectBloc>(context)
                .add(RedirectToLoginPageEvent()),
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Авторизация через VK",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        );
      default:
        return AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: null,
          title: Text(
            "По умолчанию",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        );
    }
  }
}
