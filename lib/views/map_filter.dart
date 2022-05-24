import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/map/map_bloc.dart';
import '../utils/utils_widgets.dart';

class MapFilter extends StatefulWidget {
  MapBloc mapBloc;

  MapFilter({Key? key,required this.mapBloc}) : super(key: key);

  @override
  State<MapFilter> createState() => _MapFilterState();
}

class _MapFilterState extends State<MapFilter> {
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
        title: Text("Фильтр карт",
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
                Text("Отображение",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1!.color
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top:10,bottom: 10),
                  child: CustomToggle(
                    items: ["Спутник","Схема","Гибрид"],
                    selectedIndex: widget.mapBloc.mapType.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.mapBloc.add(MapTypeChangedEvent(
                          MapType.values[index]
                        ));
                      }
                    },
                  ),
                ),
                Text("Пробки",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1!.color
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: CustomToggle(
                    items: ["ВЫКЛ","ВКЛ"],
                    selectedIndex: widget.mapBloc.showTraffic?1:0,
                    onToggle: (index){
                      if(index!=null){
                        widget.mapBloc.add(TrafficChangedEvent(
                            index==1?true:false
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
