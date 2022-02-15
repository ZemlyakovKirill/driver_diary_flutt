part of 'cost_bloc.dart';

@immutable
abstract class CostState {}

class CostInitial extends CostState {}

class CostListDataReceived extends CostState{}

class CostTypeDataReceived extends CostState{}

class CostListError extends CostState{
  final String errorMessage;

  CostListError(this.errorMessage);
}

class CostTypeError extends CostState{
  final String errorMessage;

  CostTypeError(this.errorMessage);
}
