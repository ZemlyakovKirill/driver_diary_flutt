

import 'package:driver_diary/utils/http_utils.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/material.dart';

import '../blocs/cost/cost_bloc.dart';
import '../utils/utils_widgets.dart';

class CostFilter extends StatefulWidget {
  CostBloc costBloc;

  CostFilter({Key? key,required this.costBloc}) : super(key: key);

  @override
  State<CostFilter> createState() => _CostFilterState();
}

enum CostSearchFilter{
  date,
  value,
  type,
}

extension CostSearchFilterExt on CostSearchFilter{
  String asParameter(){
    switch(this){
      case CostSearchFilter.date:
        return "date";
      case CostSearchFilter.type:
        return "type";
      case CostSearchFilter.value:
        return "value";
    }
  }
}

class _CostFilterState extends State<CostFilter> {
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
        title: Text("Фильтр расходов",
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
                    items: ["Дате","Величине","Типу"],
                    selectedIndex: widget.costBloc.searchFilter.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.costBloc.add(CostSearchFilterChangedEvent(
                            CostSearchFilter.values[index]
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
                    selectedIndex: widget.costBloc.direction.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.costBloc.add(CostDirectionChangedEvent(
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
