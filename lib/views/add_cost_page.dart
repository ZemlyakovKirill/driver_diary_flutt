import 'package:driver_diary/blocs/cost/cost_bloc.dart' as ct;
import 'package:driver_diary/utils/date_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/vehicle/vehicle_bloc.dart';
import '../enums/cost_enum.dart';
import '../models/cost_model.dart';
import '../models/vehicle_model.dart';
import '../utils/msg_utils.dart';

class AddCostPage extends StatefulWidget {
  AddCostPage({Key? key, required this.costBloc, required this.vehicleBloc})
      : super(key: key);
  ct.CostBloc costBloc;
  VehicleBloc vehicleBloc;

  @override
  _AddCostPageState createState() => _AddCostPageState();
}

class _AddCostPageState extends State<AddCostPage> {
  List<ExpandableController> _expandableControllers = List.empty();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.vehicleBloc.state is VehicleInitial) {
      widget.vehicleBloc.add(GetVehiclesEvent());
    }
    return BlocListener<ct.CostBloc, ct.CostState>(
      bloc: widget.costBloc,
      listener: (context, state) {
        if (state is ct.CostErrorState) {
          errorSnack(context, state.errorMessage);
        }
        if (state is ct.ValidationErrorState) {
          errorSnack(context, state.errorMessage);
        }
        if (state is ct.CostAddedState) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
            "Добавление расхода",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        ),
        body: BlocConsumer<VehicleBloc, VehicleState>(
          bloc: widget.vehicleBloc,
          listener: (context, state) {
            if (state is VehicleErrorState) {
              errorSnack(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            List<Vehicle>? vehicles = widget.vehicleBloc.vehicles;
            if (vehicles != null) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      if (_expandableControllers.length <= index) {
                        _expandableControllers = vehicles
                            .map((e) => ExpandableController())
                            .toList();
                      }
                      TextEditingController costController =
                          TextEditingController();
                      CostType? costType;
                      DateTime costDate = DateTime.now();
                      return _CostAddingWidget(
                        vehicleBloc: widget.vehicleBloc,
                        vehicle: vehicles[index],
                        costBloc: widget.costBloc,
                        onAdd: _addCost,
                      );
                    }),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _addCost(Vehicle vehicle, CostType? costType, String costValue,
      DateTime costDate) {
    if (costType == null) {
      errorSnack(context, "Тип расхода не может быть пустым");
      return;
    }
    if (costValue.isEmpty) {
      errorSnack(context, "Цена не может быть пустой");
      return;
    }
    double? doubleCost = double.tryParse(costValue);
    if (doubleCost == null) {
      errorSnack(context, "Цена введена неверно");
      return;
    }
    Cost cost = Cost(
        vehicle: vehicle,
        type: costType,
        costId: -1,
        value: doubleCost,
        date: costDate);
    widget.costBloc.add(ct.CostAddEvent(cost));
  }
}

class _CostAddingWidget extends StatefulWidget {
  _CostAddingWidget(
      {Key? key,
      required this.costBloc,
      required this.vehicleBloc,
      required this.vehicle,
      required this.onAdd})
      : super(key: key);
  ct.CostBloc costBloc;
  VehicleBloc vehicleBloc;
  Vehicle vehicle;
  Function(Vehicle vehicle, CostType? costType, String costValue,
      DateTime costDate) onAdd;

  @override
  _CostAddingWidgetState createState() => _CostAddingWidgetState();
}

class _CostAddingWidgetState extends State<_CostAddingWidget> {
  ExpandableController _expandableController = ExpandableController();
  CostType? _costType;
  DateTime _costDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  TextEditingController _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _expandableController.expanded = !_expandableController.expanded;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ExpandableNotifier(
          controller: _expandableController,
          child: Expandable(
            collapsed: Text(
              '${widget.vehicle.mark} ${widget.vehicle.model}'.toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Manrope",
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            expanded: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.vehicle.mark} ${widget.vehicle.model} ${widget.vehicle.licensePlateNumber}'
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Тип",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<CostType>(
                              value: _costType,
                              icon: null,
                              dropdownElevation: 0,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              customButton: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(_costType != null
                                    ? _costType!.getAsInput()
                                    : "Тип расхода"),
                              ),
                              isDense: true,
                              iconSize: 0.0,
                              dropdownWidth: 150,
                              buttonWidth: 150,
                              alignment: Alignment.center,
                              items: CostType.values
                                  .toList()
                                  .map((e) => DropdownMenuItem<CostType>(
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _costType = value!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Величина",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                          Container(
                            width: width * 0.25,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).canvasColor,
                            ),
                            child: TextField(
                              controller: _costController,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                hintText: "цена",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Дата",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  fontFamily: "Manrope"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: GestureDetector(
                              onTap: () async {
                                _costDate = await showDatePicker(
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
                                        },
                                        context: context,
                                        initialDate: _costDate,
                                        firstDate: DateTime(2009),
                                        lastDate: DateTime(
                                            DateTime.now().year + 3)) ??
                                    _costDate;
                                _costDate=_costDate.applied(await showTimePicker(
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
                                DateFormat("dd.MM.yyyy").format(_costDate),
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
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.button!.color,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => widget.onAdd(widget.vehicle, _costType,
                          _costController.text, _costDate),
                      child: Text(
                        "Добавить",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
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
        ),
      ),
    );
  }
}
