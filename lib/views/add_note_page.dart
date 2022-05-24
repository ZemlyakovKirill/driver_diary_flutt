import 'dart:developer';

import 'package:driver_diary/utils/date_utils.dart';
import 'package:driver_diary/utils/utils_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/note/note_bloc.dart' as nt;
import '../blocs/vehicle/vehicle_bloc.dart';
import '../enums/cost_enum.dart';
import '../models/note_model.dart';
import '../models/vehicle_model.dart';
import '../utils/msg_utils.dart';

class AddNotePage extends StatefulWidget {
  AddNotePage({Key? key, required this.bloc, required this.vehicleBloc})
      : super(key: key);
  nt.NoteBloc bloc;
  VehicleBloc vehicleBloc;

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _descController = TextEditingController();
  TextEditingController _valueController = TextEditingController();
  DateTime _endNoteDate = DateTime.now();
  TimeOfDay _timeOfDay=TimeOfDay.now();
  bool _isCost = false;
  bool _isCompleted = false;
  Vehicle? _vehicle;
  CostType? _costType;

  @override
  Widget build(BuildContext context) {
    if (widget.vehicleBloc.state is VehicleInitial) {
      widget.vehicleBloc.add(GetVehiclesEvent());
    }
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        title: Text(
          "Добавление заметки",
          style:
              TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
      body: BlocListener<nt.NoteBloc, nt.NoteState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if(state is nt.NotesErrorState){
              errorSnack(context, state.errorMessage);
            }
            if(state is nt.ValidationErrorState){
              errorSnack(context, state.errorMessage);
            }
            if(state is nt.CostNoteAddedState||state is nt.NotCostNoteAddedState){
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            child: LayoutBuilder(
              builder: (context,viewport) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewport.maxHeight
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomToggle(
                                  items: ["Расход", "Не расход"],
                                  selectedIndex: _isCost ? 0 : 1,
                                  onToggle: (value) {
                                    _costChanged(value == 0);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomToggle(
                                    items: ["Не выполнена", "Выполнена"],
                                    minWidth: 130,
                                    selectedIndex: _isCompleted ? 1 : 0,
                                    onToggle: (value) {
                                      _isCompleted = value == 1;
                                    },
                                  ),
                                ),
                                BlocConsumer<VehicleBloc, VehicleState>(
                                  bloc: widget.vehicleBloc,
                                  listener: (context,vState){
                                    if(vState is VehicleErrorState){
                                      errorSnack(context,vState.errorMessage);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (_isCost &&
                                        widget.vehicleBloc.vehicles != null) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.4,
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .canvasColor,
                                            ),
                                            child: TextField(
                                              controller: _valueController,
                                              style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                                  fontFamily: "Manrope",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600
                                              ),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 2),
                                                hintText: "Значение",
                                                hintStyle: TextStyle(
                                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                                    fontFamily: "Manrope",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<CostType>(
                                                value: _costType,
                                                icon: null,
                                                dropdownElevation: 0,
                                                customButton: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                  child: Text(_costType != null
                                                      ? _costType!.getAsInput()
                                                      : "Выберите тип расхода",
                                                    style: TextStyle(
                                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                                        fontFamily: "Manrope",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                                isDense: true,
                                                iconSize: 0.0,
                                                dropdownWidth: 150,
                                                buttonWidth: 150,
                                                alignment: Alignment.center,
                                                items: CostType.values
                                                    .toList()
                                                    .map((e) => DropdownMenuItem<
                                                            CostType>(
                                                        value: e,
                                                        child: Center(
                                                          child: Text(
                                                            e.getAsInput(),
                                                            style: TextStyle(
                                                                color: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .color,
                                                                fontFamily: "Manrope",
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight.w600),
                                                          ),
                                                        )))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _costType = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<Vehicle>(
                                                value: _vehicle,
                                                icon: null,
                                                dropdownElevation: 0,
                                                customButton: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                  child: Text(_vehicle != null
                                                      ? "${_vehicle!.mark} ${_vehicle!.model} ${_vehicle!.licensePlateNumber}"
                                                      : "Выберите ТС",
                                                    style: TextStyle(
                                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                                        fontFamily: "Manrope",
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                                isDense: true,
                                                iconSize: 0.0,
                                                dropdownWidth: 150,
                                                buttonWidth: 150,
                                                alignment: Alignment.center,
                                                items: widget.vehicleBloc.vehicles!
                                                    .map((e) => DropdownMenuItem<
                                                            Vehicle>(
                                                        value: e,
                                                        child: Center(
                                                          child: Text(
                                                            "${e.mark} ${e.model} ${e.licensePlateNumber}",
                                                            style: TextStyle(
                                                                color: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .color,
                                                                fontFamily: "Manrope",
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight.w600),
                                                          ),
                                                        )))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _vehicle = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.4,
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .canvasColor,
                                            ),
                                            child: TextField(
                                              controller: _descController,
                                              style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                                  fontFamily: "Manrope",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600
                                              ),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 2),
                                                hintText: "Описание",
                                                hintStyle: TextStyle(
                                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                                    fontFamily: "Manrope",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                  child: GestureDetector(
                                    onTap: () async {
                                      _endNoteDate = await showDatePicker(
                                              builder: (context, child) {
                                                ThemeData prevTheme = Theme.of(context);
                                                return Theme(
                                                  data: ThemeData(
                                                    dialogTheme: const DialogTheme(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20)))),
                                                    fontFamily: "Manrope",
                                                    colorScheme: ColorScheme.light(
                                                        primary: prevTheme.primaryColor,
                                                        onSurface:
                                                            prevTheme.canvasColor,
                                                        onPrimary: prevTheme.textTheme
                                                            .bodyText1!.color!),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style: TextButton.styleFrom(
                                                        primary: Colors
                                                            .red, // button text color
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                              context: context,
                                              initialDate: _endNoteDate,
                                              firstDate: DateTime(2009),
                                              lastDate:
                                                  DateTime(DateTime.now().year + 3)) ??
                                          _endNoteDate;
                                      _endNoteDate=_endNoteDate.applied(await showTimePicker(
                                          context: context,
                                          initialTime: _timeOfDay,
                                          builder: (context, child) {
                                            ThemeData prevTheme =
                                            Theme.of(context);
                                            return Theme(
                                              data: ThemeData(
                                                dialogTheme: const DialogTheme(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)))),
                                                fontFamily: "Manrope",
                                                colorScheme: ColorScheme.light(
                                                    primary:
                                                    prevTheme.primaryColor,
                                                    onSurface:
                                                    prevTheme.canvasColor,
                                                    onPrimary: prevTheme.textTheme
                                                        .bodyText1!.color!),
                                                textButtonTheme:
                                                TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    primary: Colors
                                                        .red, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          }) ??
                                          _timeOfDay);
                                      setState(() {});
                                    },
                                    child: Text(
                                      DateFormat("dd.MM.yyyy").format(_endNoteDate),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                          fontFamily: "Manrope",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).textTheme.button!.color,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () => _addNote(),
                                      child: Text(
                                        "Добавить",
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
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )),
    );
  }

  void _addNote() {
    if (_isCost) {
      double? value = double.tryParse(_valueController.text);
      if (value == null) {
        errorSnack(context, "Значение введено неправильно");
        return;
      }
      if (_costType == null) {
        errorSnack(context, "Тип расхода не выбран");
        return;
      }
      if (_vehicle == null) {
        errorSnack(context, "ТС не выбрано");
        return;
      }
      Note costNote = Note(
          noteID: -1,
          endDate: _endNoteDate,
          isCompleted: _isCompleted,
          isCost: true,
          value: value,
          costType: _costType,
          vehicle: _vehicle);
      widget.bloc.add(nt.AddCostNoteEvent(costNote));
    } else {
      Note note = Note(
        noteID: -1,
        description: _descController.text,
        isCost: false,
        endDate: _endNoteDate,
        isCompleted: _isCompleted,
      );
      widget.bloc.add(nt.AddNotCostNoteEvent(note));
    }
  }

  _costChanged(bool newType) {
    setState(() {
      _isCost = newType;
    });
  }
}
