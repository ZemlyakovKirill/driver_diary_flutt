import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  int _pageIndex = 0;

  PageBloc() : super(PageInitial()) {
    on<ChangePageEvent>((event, emit) {
      _pageIndex = event.pageIndex;
      if (event.pageIndex == 1) {
        emit(PageChangedState(pageIndex: _pageIndex, tabsCount: 2));
        return;
      } else if (event.pageIndex == 2) {
        emit(PageChangedState(pageIndex: _pageIndex, tabsCount: 3));
        return;
      }
      emit(PageChangedState(pageIndex: _pageIndex, tabsCount: 0));
    });
  }

  @override
  void onChange(Change<PageState> change) {
    super.onChange(change);
    log('PageBloc -> ' + change.nextState.toString());
  }
}
