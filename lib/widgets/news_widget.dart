import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class News{
  String title;
  String description;
  String? imgLink;
  String? author;
  DateTime? pubDate;

  News({required this.title,required this.description, this.imgLink,this.author,this.pubDate});

  Widget panel(BuildContext context) {
    ExpandableController _controller=ExpandableController(initialExpanded: false);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme
              .of(context)
              .canvasColor),
      width: double.infinity,
      child: ExpandableNotifier(
        child: Expandable(
          controller: _controller,
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
                    author ?? "",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFFB4B4B4),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat("dd MMMM yy").format(
                        (pubDate ?? DateTime.now())).toString(),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFFB4B4B4),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imgLink ??
                          "https://cdn3.vectorstock.com/i/1000x1000/87/02/auto-car-logo-template-icon-vector-21468702.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(1, -0.05),
                      child: Text(
                        DateFormat("hh:mm")
                            .format((pubDate ?? DateTime.now()))
                            .toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFFB4B4B4),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          expanded: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    author ?? "",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFFB4B4B4),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat("dd M yyyy").format(
                        (pubDate ?? DateTime.now())).toString(),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color(0xFFB4B4B4),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imgLink ??
                          "https://cdn3.vectorstock.com/i/1000x1000/87/02/auto-car-logo-template-icon-vector-21468702.jpg",
                      width: 50,
                      height: 50,
                      color: Theme
                          .of(context)
                          .canvasColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat("H:mm")
                            .format((pubDate ?? DateTime.now()))
                            .toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color(0xFFB4B4B4),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

