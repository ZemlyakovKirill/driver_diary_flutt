import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_diary/utils/my_custom_icons_icons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewsWidget extends StatefulWidget {
  String title;
  String description;
  String imageLink;
  String? author;
  String prettyDate;

  NewsWidget({Key? key,required this.title,required this.description, required this.imageLink,this.author,required this.prettyDate})
  :super(key:key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final ExpandableController _expandableController=ExpandableController();


  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _expandableController.expanded=!_expandableController.expanded;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme
                .of(context)
                .primaryColor),
        width: double.infinity,
        child: ExpandableNotifier(
          controller: _expandableController,
          child: Expandable(
            theme: const ExpandableThemeData(
                crossFadePoint: 0,
                tapBodyToCollapse: true,
                tapBodyToExpand: true,
                hasIcon: false),
            collapsed: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.author ?? "",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.prettyDate,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageLink,
                    placeholder: (context,_)=>CircularProgressIndicator(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    errorWidget: (context,_,__)=>Icon(
                      MyCustomIcons.app_icon,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      size: 24,
                    ),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                )
              ],
            ),
            expanded: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.author ?? "",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.prettyDate,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageLink,
                      placeholder: (context,_)=>CircularProgressIndicator(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      errorWidget: (context,_,__)=>Icon(
                        MyCustomIcons.app_icon,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        size: 48,
                      ),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyText1!.color
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




