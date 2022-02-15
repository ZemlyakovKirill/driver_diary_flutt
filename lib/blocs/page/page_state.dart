part of 'page_bloc.dart';

@immutable
abstract class PageState {}

class PageInitial extends PageState {}

class PageChangedState extends PageState{
  final int pageIndex;
  final int tabsCount;

  PageChangedState({required this.pageIndex, required this.tabsCount});
}
