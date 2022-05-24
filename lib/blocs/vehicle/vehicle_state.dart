part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleState {}

class VehicleInitial extends VehicleState {}
class VehicleDataReceivedState extends VehicleState {

}
class VehicleAddedState extends VehicleState{}
class VehicleEditedState extends VehicleState{}
class VehicleDeletedState extends VehicleState{}
class LoadingState extends VehicleState{}
class ValidationErrorState extends VehicleState{
  final String message;
  ValidationErrorState(this.message);
}
class VehicleErrorState extends VehicleState {
  final String errorMessage;

  VehicleErrorState(this.errorMessage);
}
