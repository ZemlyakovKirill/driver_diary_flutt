
import 'package:driver_diary/blocs/map/map_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cost/cost_bloc.dart';
import '../blocs/news/news_bloc.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/personal/personal_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';

class StompListener extends StatefulWidget {
  StompListener({Key? key,required this.child}) : super(key: key);
  Widget child;

  @override
  _StompListenerState createState() => _StompListenerState();
}

class _StompListenerState extends State<StompListener> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<StompBloc,StompState>(
      listener: (context, state){
        if(state is VehiclesDataReceivedState){
          BlocProvider.of<VehicleBloc>(context).add(GetVehiclesEvent());
        } else if(state is CostsDataReceivedState){
          BlocProvider.of<CostBloc>(context).add(CostMonthsGetEvent());
        } else if(state is UserDataReceivedState){
          BlocProvider.of<PersonalBloc>(context).add(GetPersonalDataEvent());
        } else if(state is NotesDataReceivedState){
          BlocProvider.of<NoteBloc>(context).add(GetNotesOverdued());
          BlocProvider.of<NoteBloc>(context).add(GetNotesCompleted());
          BlocProvider.of<NoteBloc>(context).add(GetNotesUncompleted());
        } else if(state is NewsDataReceivedState){
          BlocProvider.of<NewsBloc>(context).add(GetNewsEvent());
        } else if(state is MarkersDataReceivedState){
          var mode = BlocProvider.of<ThemeBloc>(context).mode;
          BlocProvider.of<MapBloc>(context).add(GetMarkersEvent(mode));
        }
      },
      child: widget.child,
    );
  }
}
