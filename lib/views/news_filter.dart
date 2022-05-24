


import 'package:driver_diary/utils/http_utils.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:flutter/material.dart';

import '../blocs/news/news_bloc.dart';
import '../utils/utils_widgets.dart';

class NewsFilter extends StatefulWidget {
  NewsBloc newsBloc;

  NewsFilter({Key? key,required this.newsBloc}) : super(key: key);

  @override
  State<NewsFilter> createState() => _NewsFilterState();
}

enum NewsSearchFilter{
  date,
  author
}

extension NewsSearchFilterExt on NewsSearchFilter{
  String asParameter(){
    switch(this){
      case NewsSearchFilter.date:
        return "pubDate";
      case NewsSearchFilter.author:
        return "author";
    }
  }
}

class _NewsFilterState extends State<NewsFilter> {
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
        title: Text("Фильтр новостей",
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
                  padding: const EdgeInsets.only(top:10),
                  child: CustomToggle(
                    items: ["Дате","Автору"],
                    selectedIndex: widget.newsBloc.searchFilter.index,
                    onToggle: (index){
                      if(index!=null){
                        widget.newsBloc.add(NewsSearchFilterChangedEvent(
                            NewsSearchFilter.values[index]
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
