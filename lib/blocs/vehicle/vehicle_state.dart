part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleState {}

class VehicleInitial extends VehicleState {}
class VehicleDataReceivedState extends VehicleState {}
class VehicleErrorState extends VehicleState {
  final String errorMessage;

  VehicleErrorState(this.errorMessage);
}
