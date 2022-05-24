part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class GetNewsEvent extends NewsEvent{}

class NewsSearchFilterChangedEvent extends NewsEvent{
  final NewsSearchFilter searchFilter;

  NewsSearchFilterChangedEvent(this.searchFilter);
}
