part of 'cost_bloc.dart';

@immutable
abstract class CostEvent {}

class CostListGetEvent extends CostEvent{}
class CostTypeGetEvent extends CostEvent{}
class CostDeleteEvent extends CostEvent{}