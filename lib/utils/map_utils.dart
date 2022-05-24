import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showMarkerInfo(BuildContext context,
    {required String name, required String type}) async {
  double? height = AppBar().preferredSize.height;
  await showAlignedDialog(
    context: context,
    targetAnchor: Alignment.topCenter,
    avoidOverflow: true,
    offset: Offset(0, height),
    barrierColor: Colors.transparent,
    transitionsBuilder: null,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy < -10) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(15))),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Тип:",
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              fontFamily: "Manrope"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            type,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Manrope"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Наименование:",
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              fontFamily: "Manrope"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            name,
                            maxLines: 5,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Manrope"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .textTheme
                            .button!
                            .color,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: null,
                        child: Text(
                          "Проложить маршрут",
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w500,
                              fontSize: 9),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          width: 60,
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      );
    },
  );
}

Future<void> showAddingMarkerDialog(BuildContext context,
    {required double lat, required double lon}) async {
  double? height = AppBar().preferredSize.height;
  await showAlignedDialog(
    context: context,
    targetAnchor: Alignment.topCenter,
    avoidOverflow: true,
    offset: Offset(0, height),
    barrierColor: Colors.transparent,
    transitionsBuilder: null,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Тип",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: "Manrope"),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 10,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Наименование",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Manrope"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .textTheme
                          .button!
                          .color,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: null,
                      child: Text(
                        "Проложить маршрут",
                        style: TextStyle(
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .color,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w500,
                            fontSize: 9),
                      ),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      width: 100,
                      child: GestureDetector(
                        onTap: null,
                        child: Container(
                          color: Colors.grey,
                          width: 60,
                          height: 5,
                        ),
                      ))
                ],
              ),
            )),
      );
    },
  );
}
