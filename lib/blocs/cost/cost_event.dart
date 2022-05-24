part of 'cost_bloc.dart';

@immutable
abstract class CostEvent {}

class CostListGetEvent extends CostEvent{
  final Month month;

  CostListGetEvent(this.month);
}
class CostTypeGetEvent extends CostEvent{
  final Month month;

  CostTypeGetEvent(this.month);
}

class CostSearchFilterChangedEvent extends CostEvent{
  final CostSearchFilter searchFilter;

  CostSearchFilterChangedEvent(this.searchFilter);
}
class CostDeleteEvent extends CostEvent{
  final Cost cost;

  CostDeleteEvent(this.cost);
}

class CostDirectionChangedEvent extends CostEvent{
  final Direction direction;

  CostDirectionChangedEvent(this.direction);
}
class CostAddEvent extends CostEvent{
  final Cost cost;

  CostAddEvent(this.cost);
}

class CostMonthsGetEvent extends CostEvent{}