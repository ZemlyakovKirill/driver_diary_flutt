import 'package:driver_diary/utils/msg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/vehicle/vehicle_bloc.dart';
import '../models/vehicle_model.dart';

class EditVehiclePage extends StatefulWidget {
  EditVehiclePage({Key? key, required this.bloc, required this.vehicle})
      : super(key: key);
  final VehicleBloc bloc;
  final Vehicle vehicle;

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  TextEditingController _markController = TextEditingController();

  TextEditingController _modelController = TextEditingController();

  TextEditingController _generationController = TextEditingController();

  TextEditingController _fuelCapacityController = TextEditingController();

  TextEditingController _licensePlateNumberController = TextEditingController();

  TextEditingController _consumptionCityController = TextEditingController();

  TextEditingController _consumptionRouteController = TextEditingController();

  TextEditingController _consumptionMixedController = TextEditingController();

  @override
  void initState() {
    _markController.text = widget.vehicle.mark;
    _modelController.text = widget.vehicle.model;
    _generationController.text = widget.vehicle.generation ?? "";
    _fuelCapacityController.text = widget.vehicle.fuelCapacity.toString();
    _licensePlateNumberController.text =
        widget.vehicle.licensePlateNumber ?? "";
    _consumptionCityController.text = widget.vehicle.consumptionCity.toString();
    _consumptionMixedController.text =
        widget.vehicle.consumptionMixed.toString();
    _consumptionRouteController.text =
        widget.vehicle.consumptionRoute.toString();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
            "Редактирование ТС",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
        ),
        body: BlocListener<VehicleBloc, VehicleState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if (state is ValidationErrorState) {
              errorSnack(context, state.message);
            }
            if (state is VehicleErrorState) {
              errorSnack(context, state.errorMessage);
            }
            if (state is VehicleEditedState) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15)),
              child: LayoutBuilder(builder: (context, constr) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constr.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _markController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Марка",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _modelController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Модель",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _generationController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Поколение",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _fuelCapacityController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Запас топлива",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).canvasColor),
                            child: TextField(
                              controller: _licensePlateNumberController,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontFamily: "Manrope",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                              decoration: InputDecoration(
                                hintText: "Регистрационный номер",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText2!.color,
                                    fontFamily: "Manrope",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text(
                            "Расход",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontFamily: "Manrope",
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth * 0.2,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).canvasColor),
                                  child: TextField(
                                    controller: _consumptionCityController,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontFamily: "Manrope",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Город",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).textTheme.bodyText2!.color,
                                          fontFamily: "Manrope",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.2,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).canvasColor),
                                  child: TextField(
                                    controller: _consumptionRouteController,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontFamily: "Manrope",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Трасса",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).textTheme.bodyText2!.color,
                                          fontFamily: "Manrope",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenWidth * 0.2,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).canvasColor),
                                  child: TextField(
                                    controller: _consumptionMixedController,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontFamily: "Manrope",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Смеш.",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).textTheme.bodyText1!.color,
                                          fontFamily: "Manrope",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                      ),
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () => _addVehicle(context),
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).canvasColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              child: Text("Редактировать",
                                  style: TextStyle(
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color)))
                        ],
                      ),
                    ),
                  ),
                );
              })),
        ));
  }

  void _addVehicle(BuildContext context) {
    double? city = double.tryParse(_consumptionCityController.text);
    double? route = double.tryParse(_consumptionRouteController.text);
    double? mixed = double.tryParse(_consumptionMixedController.text);
    if (mixed == null) {
      errorSnack(context, "Расход в смешанном цикле введен неправильно");
      return;
    }
    if (route == null) {
      errorSnack(context, "Расход на трассе введен неправильно");
      return;
    }
    if (city == null) {
      errorSnack(context, "Расход в городе введен неправильно");
      return;
    }
    Vehicle vehicle = Vehicle(
      id: widget.vehicle.id,
      mark: _markController.text,
      model: _modelController.text,
      generation: _generationController.text,
      consumptionCity: city,
      consumptionRoute: route,
      consumptionMixed: mixed,
      licensePlateNumber: _licensePlateNumberController.text,
      fuelCapacity: double.parse(_fuelCapacityController.text),
    );
    widget.bloc.add(EditVehicleEvent(vehicle));
  }
}
