import 'package:driver_diary/blocs/cost/cost_bloc.dart';
import 'package:driver_diary/blocs/page/page_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

class CostPage extends StatelessWidget {
  const CostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageBloc=BlocProvider.of<PageBloc>(context);
    final _costBloc = BlocProvider.of<CostBloc>(context);
    return BlocListener<StompBloc, StompState>(
      listener: (context, state) {
        if (state is CostsDataReceivedState) {
          _costBloc.add(CostListGetEvent());
          _costBloc.add(CostTypeGetEvent());
        }
      },
  child: Builder(
      builder: (context) {
        if(_pageBloc.state is PageChangedState && (_pageBloc.state as PageChangedState).tabsCount==2){
        return TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          CostListPage(),
          CostTypePage(),
        ]);
      }return Container();
    }
    ),
);
  }
}

class CostListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _costBloc = BlocProvider.of<CostBloc>(context);
    if (_costBloc.listCosts == null) {
      _costBloc.add(CostListGetEvent());
    }
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: BlocConsumer<CostBloc, CostState>(
          listener: (context, state) {
            if (state is CostListError) {
              errorSnack(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (_costBloc.listCosts != null && _costBloc.total != null) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Общий:",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          '${_costBloc.total!.toStringAsFixed(2)}Р',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontSize: 14,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: _costBloc.listCosts!.length,
                      itemBuilder: (context, index) =>
                          _costBloc.listCosts![index].getAsWidget(context),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        borderRadius: BorderRadius.circular(15),
                        height: 10,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,

                    itemCount: 5,
                    itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: Column(
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                borderRadius: BorderRadius.circular(15),
                                height: 10,
                                width: 40,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      borderRadius: BorderRadius.circular(15),
                                      height: 15,
                                      width: 45,
                                    ),
                                  ),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      borderRadius: BorderRadius.circular(15),
                                      height: 10,
                                      width: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    borderRadius: BorderRadius.circular(15),
                                    height: 15,
                                    width: 50,
                                  ),
                                ),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    borderRadius: BorderRadius.circular(15),
                                    height:10,
                                    width: 45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CostTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _costBloc = BlocProvider.of<CostBloc>(context);
    if (_costBloc.typeCosts == null) {
      _costBloc.add(CostTypeGetEvent());
    }
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: BlocConsumer<CostBloc, CostState>(
          listener: (context, state) {
            if (state is CostTypeError) {
              errorSnack(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (_costBloc.typeCosts != null && _costBloc.total != null) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Общий:",
                        style: TextStyle(
                            color:
                            Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 14,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          '${_costBloc.total!.toStringAsFixed(2)}Р',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color,
                              fontSize: 14,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: _costBloc.typeCosts!.length,
                      itemBuilder: (context, index) =>
                          _costBloc.typeCosts![index].getAsWidget(context),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        borderRadius: BorderRadius.circular(15),
                        height: 10,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,

                    itemCount: 5,
                    itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: Column(
                          children: [
                            SkeletonLine(
                              style: SkeletonLineStyle(
                                borderRadius: BorderRadius.circular(15),
                                height: 10,
                                width: 40,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      borderRadius: BorderRadius.circular(15),
                                      height: 15,
                                      width: 45,
                                    ),
                                  ),
                                  SkeletonLine(
                                    style: SkeletonLineStyle(
                                      borderRadius: BorderRadius.circular(15),
                                      height: 10,
                                      width: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    borderRadius: BorderRadius.circular(15),
                                    height: 15,
                                    width: 50,
                                  ),
                                ),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    borderRadius: BorderRadius.circular(15),
                                    height:10,
                                    width: 45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
