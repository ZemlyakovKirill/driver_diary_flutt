import 'package:driver_diary/blocs/note/note_bloc.dart';
import 'package:driver_diary/blocs/page/page_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageBloc = BlocProvider.of<PageBloc>(context);
    final _noteBloc = BlocProvider.of<NoteBloc>(context);
    return BlocListener<StompBloc, StompState>(
      listener: (context, state) {
        _noteBloc.add(GetNotesOverdued());
        _noteBloc.add(GetNotesCompleted());
        _noteBloc.add(GetNotesUncompleted());
      },
      child: Builder(builder: (context) {
        if (_pageBloc.state is PageChangedState &&
            (_pageBloc.state as PageChangedState).tabsCount == 3) {
          return TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            NoteUncompletedPage(),
            NoteCompletedPage(),
            NoteOverduedPage()
          ]);
        }
        return Container();
      }),
    );
  }
}

class NoteOverduedPage extends StatelessWidget {
  NoteOverduedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _noteBloc = BlocProvider.of<NoteBloc>(context);
    if (_noteBloc.overduedNotes == null) {
      _noteBloc.add(GetNotesOverdued());
    }
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: BlocConsumer<NoteBloc, NoteState>(listener: (cont, state) {
          if (state is NotesOverduedErrorState) {
            errorSnack(cont, state.errorMessage);
          }
        }, builder: (cont, state) {
          if (_noteBloc.overduedNotes != null) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _noteBloc.overduedNotes!.length,
              itemBuilder: (BuildContext context, int index) =>
                  _noteBloc.overduedNotes![index].getAsWidget(context),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (cont, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).canvasColor),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            borderRadius: BorderRadius.circular(15),
                            height: 7,
                            width: 40,
                          ),
                        ),
                        SkeletonLine(
                          style: SkeletonLineStyle(height: 5, width: 40),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: 50,
                                height: 50,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                                borderRadius: BorderRadius.circular(15),
                                height: 5,
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              borderRadius: BorderRadius.circular(15),
                              height: 10,
                              width: 100),
                        ))
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class NoteCompletedPage extends StatelessWidget {
  NoteCompletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _noteBloc = BlocProvider.of<NoteBloc>(context);
    if (_noteBloc.completedNotes == null) {
      _noteBloc.add(GetNotesCompleted());
    }
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: BlocConsumer<NoteBloc, NoteState>(listener: (cont, state) {
          if (state is NotesCompletedErrorState) {
            errorSnack(cont, state.errorMessage);
          }
        }, builder: (cont, state) {
          if (_noteBloc.completedNotes != null) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _noteBloc.completedNotes!.length,
              itemBuilder: (BuildContext context, int index) =>
                  _noteBloc.completedNotes![index].getAsWidget(context),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (cont, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).canvasColor),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            borderRadius: BorderRadius.circular(15),
                            height: 7,
                            width: 40,
                          ),
                        ),
                        SkeletonLine(
                          style: SkeletonLineStyle(height: 5, width: 40),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: 50,
                                height: 50,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                                borderRadius: BorderRadius.circular(15),
                                height: 5,
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              borderRadius: BorderRadius.circular(15),
                              height: 10,
                              width: 100),
                        ))
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class NoteUncompletedPage extends StatelessWidget {
  NoteUncompletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _noteBloc = BlocProvider.of<NoteBloc>(context);
    if (_noteBloc.uncompletedNotes == null) {
      _noteBloc.add(GetNotesUncompleted());
    }
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: BlocConsumer<NoteBloc, NoteState>(listener: (cont, state) {
          if (state is NotesUncompletedErrorState) {
            errorSnack(cont, state.errorMessage);
          }
        }, builder: (cont, state) {
          if (_noteBloc.uncompletedNotes != null) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _noteBloc.uncompletedNotes!.length,
              itemBuilder: (BuildContext context, int index) =>
                  _noteBloc.uncompletedNotes![index].getAsWidget(context),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (cont, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).canvasColor),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            borderRadius: BorderRadius.circular(15),
                            height: 7,
                            width: 40,
                          ),
                        ),
                        SkeletonLine(
                          style: SkeletonLineStyle(height: 5, width: 40),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                width: 50,
                                height: 50,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                                borderRadius: BorderRadius.circular(15),
                                height: 5,
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              borderRadius: BorderRadius.circular(15),
                              height: 10,
                              width: 100),
                        ))
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
