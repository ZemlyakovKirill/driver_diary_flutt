import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/note_indicator/note_indicator_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBars extends StatelessWidget with PreferredSizeWidget {
  final int appBarValue;

  const CustomBars({Key? key, required this.appBarValue}) : super(key: key);

  @override
  Size get preferredSize =>
      Size(double.infinity, appBarValue != 1 && appBarValue != 2 ? 50 : 90);

  Widget build(BuildContext context) {
    switch (appBarValue) {
      case 0:
        return AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Icon(
            Icons.filter_list,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Карты",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        );
      case 1:
        return AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Icon(
            Icons.filter_list,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Расходы",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).textTheme.bodyText1!.color,
            tabs: [
              Tab(
                text: "Список",
              ),
              Tab(
                text: "По типу",
              ),
            ],
          ),
        );
      case 2:
        final _indicBloc=BlocProvider.of<NoteIndicatorBloc>(context)..add(NoteTypeChangedEvent(0));
        return BlocBuilder<NoteIndicatorBloc, NoteIndicatorState>(
  builder: (context, state) {
    if(state is NoteIndicatorChangedState){
      return AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Icon(
          Icons.filter_list,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        title: Text(
          "Заметки",
          style:
          TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        bottom: TabBar(
          onTap: (value) => _indicBloc.add(NoteTypeChangedEvent(value)),
          indicatorColor: state.indicatorColor,
          tabs: [
            Tab(
                icon: Icon(Icons.hourglass_empty_outlined,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            Tab(
                icon: Icon(Icons.check_outlined,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
            Tab(
                icon: Icon(Icons.clear_outlined,
                    color: Theme.of(context).textTheme.bodyText1!.color)),
          ],
        ),
      );
    }
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).primaryColor,
      leading: Icon(
        Icons.filter_list,
        color: Theme.of(context).textTheme.bodyText1!.color,
      ),
      title: Text(
        "Заметки",
        style:
        TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  },
);
      case 3:
        return AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Icon(
            Icons.filter_list,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          title: Text(
            "Новости",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        );
      case 4:
        return AppBar(
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
        );
      case 10:
        return AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
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
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
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
