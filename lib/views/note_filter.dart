


import 'package:driver_diary/utils/http_utils.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/material.dart';

import '../blocs/note/note_bloc.dart';
import '../utils/utils_widgets.dart';

class NoteFilter extends StatefulWidget {
  NoteBloc noteBloc;

  NoteFilter({Key? key,required this.noteBloc}) : super(key: key);

  @override
  State<NoteFilter> createState() => _NoteFilterState();
}

enum NoteSearchFilter{
  endDate,
  description,
  type,
}

extension NoteSearchFilterExt on NoteSearchFilter{
  String asParameter(){
    switch(this){
      case NoteSearchFilter.endDate:
        return "endDate";
      case NoteSearchFilter.type:
        return "type";
      case NoteSearchFilter.description:
        return "description";
    }
  }
}

class _NoteFilterState extends State<NoteFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: Icon(MyCustomIcons.app_icon,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          )
        ],
        title: Text("Фильтр заметок",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyText1!.color
          ),),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Сортировать по",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1!.color
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top:10,bottom: 10),
                  child: CustomToggle(
                    items: ["Дате","Описанию","Типу"],
                    selectedIndex: widget.noteBloc.searchFilter.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.noteBloc.add(NoteSearchFilterChangedEvent(
                            NoteSearchFilter.values[index]
                        ));
                      }
                    },
                  ),
                ),
                Text("Направление",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1!.color
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: CustomToggle(
                    items: ["По возрастанию","По убыванию"],
                    minWidth: MediaQuery.of(context).size.width*0.4,
                    selectedIndex: widget.noteBloc.direction.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.noteBloc.add(NoteDirectionChangedEvent(
                            index==0?Direction.asc:Direction.desc
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
