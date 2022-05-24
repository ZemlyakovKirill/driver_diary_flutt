
import 'package:driver_diary/models/vehicle_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../blocs/note/note_bloc.dart';
import '../enums/cost_enum.dart';

class Note {
  int noteID;
  String? description;
  double? value;
  CostType? costType;
  DateTime endDate;
  String prettyDate;
  bool isCost;
  bool isCompleted;
  Vehicle? vehicle;

  Note(
      {required this.noteID,
      this.description,
      this.value,
      this.costType,
      required this.endDate,
      required this.isCost,
      required this.isCompleted,
      this.vehicle})
  :prettyDate=timeago.format(DateTime.now(),locale: "ru",allowFromNow: true)
  {
  prettyDate=timeago.format(endDate,locale: "ru",allowFromNow: true);
}

  Note.fromJson(Map<String, dynamic> json)
      : noteID = int.parse(json["id"].toString()),
        description = json["description"].toString(),
        value = double.tryParse(json["value"].toString()),
        endDate = DateFormat("MMM d, yyyy, hh:mm:ss aa")
            .parse(json['endDate'].toString()),
        prettyDate=timeago.format(DateTime.now(),locale: "ru",allowFromNow: true),
        isCost = json['isCost'] as bool,
        isCompleted = json['isCompleted'] as bool,
        costType = CostType.OTHER,
        vehicle = json["userVehicle"] != null
            ? Vehicle.fromJson(json["userVehicle"]["vehicle"])
            : null {
    costType = getCostType(json["type"].toString());
    prettyDate=timeago.format(endDate,locale: "ru",allowFromNow: true);
  }

  Widget getAsWidget(BuildContext context, NoteBloc bloc) {
    ExpandableController expandableController = ExpandableController();
    return GestureDetector(
      onTap: () {
        expandableController.expanded = !expandableController.expanded;
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor),
          child: Builder(builder: (context) {
            if (isCost) {
              return ExpandableNotifier(
                controller: expandableController,
                child: Expandable(
                  collapsed: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            costType!.getAsInput(),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => bloc.add(DeleteNoteEvent(this)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${value!.toStringAsFixed(2)} Р',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontSize: 14,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${vehicle!.mark.toUpperCase()} ${vehicle!.model.toUpperCase()}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            prettyDate,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  expanded: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            costType!.getAsInput(),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => bloc.add(DeleteNoteEvent(this)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${value!.toStringAsFixed(2)} Р',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontSize: 14,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${vehicle!.mark.toUpperCase()} ${vehicle!.model.toUpperCase()}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            prettyDate,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).textTheme.button!.color,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () => isCompleted
                                ? _uncompleteNote(bloc)
                                : _completeNote(bloc),
                            child: Text(
                              isCompleted ? "Не выполнен" : "Выполнен",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ExpandableNotifier(
                controller: expandableController,
                child: Expandable(
                  collapsed: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Заметка",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => bloc.add(DeleteNoteEvent(this)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            '$description',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            prettyDate,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  expanded: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Заметка",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () => bloc.add(DeleteNoteEvent(this)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            '$description',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            prettyDate,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                                fontSize: 12,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).textTheme.button!.color,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () => isCompleted
                                ? _uncompleteNote(bloc)
                                : _completeNote(bloc),
                            child: Text(
                              isCompleted ? "Не выполнен" : "Выполнен",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          })),
    );
  }

  void _completeNote(NoteBloc bloc) {
    bloc.add(CompleteNoteEvent(this));
  }

  void _uncompleteNote(NoteBloc bloc) {
    bloc.add(UnCompleteNoteEvent(this));
  }
}

class NoteNotCost {
  String description;
  DateTime endDate;

  NoteNotCost(this.description, this.endDate);
}
