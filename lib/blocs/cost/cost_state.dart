part of 'cost_bloc.dart';

@immutable
abstract class CostState {}

class CostInitial extends CostState {}

class CostListDataReceived extends CostState{}

class CostTypeDataReceived extends CostState{}

class CostMonthsDataReceived extends CostState{}

class CostErrorState extends CostState{
  final String errorMessage;

  CostErrorState(this.errorMessage);
}

class CostDirectionChangedState extends CostState{

}

class CostSearchFilterChangedState extends CostState{

}

class ValidationErrorState extends CostState{
  final String errorMessage;

  ValidationErrorState(this.errorMessage);
}

class CostAddedState extends CostState{}
class CostDeletedState extends CostState{}
