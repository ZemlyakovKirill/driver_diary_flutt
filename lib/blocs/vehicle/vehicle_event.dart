part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {}

class GetVehiclesEvent extends VehicleEvent{
  GetVehiclesEvent();
}


class AddVehicleEvent extends VehicleEvent{
  final Vehicle vehicle;

  AddVehicleEvent(this.vehicle);
}

class EditVehicleEvent extends VehicleEvent{
  final Vehicle vehicle;

  EditVehicleEvent(this.vehicle);
}

class DeleteVehicleEvent extends VehicleEvent{
  final Vehicle vehicle;

  DeleteVehicleEvent(this.vehicle);
}