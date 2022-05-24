import 'dart:developer';

import 'package:driver_diary/blocs/cost/cost_bloc.dart';
import 'package:driver_diary/blocs/page/page_bloc.dart';
import 'package:driver_diary/enums/month_enum.dart';
import 'package:driver_diary/utils/custom_scroll_physics.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/widgets/stomp_listener.dart';
import 'package:driver_diary/widgets/type_cost_diagram.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CostPage extends StatelessWidget {
  CostPage({Key? key}) : super(key: key);


  List<ExpandableController>? _expandableControllers;

  @override
  Widget build(BuildContext context) {
    final _costBloc = BlocProvider.of<CostBloc>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (_costBloc.state is CostInitial) {
      _costBloc.add(CostMonthsGetEvent());
    }
    var controller=ScrollController(initialScrollOffset: -100);
    return StompListener(
      child: BlocConsumer<CostBloc, CostState>(
          bloc: _costBloc,
          listener: (context, state) {
            if (state is CostErrorState) {
              errorSnack(context, state.errorMessage);
            }
            if(state is CostSearchFilterChangedState || state is CostDirectionChangedState){
              _costBloc.add(CostMonthsGetEvent());
            }
          },
          builder: (context, state) {
            if (_costBloc.months != null) {
              if(_expandableControllers==null || _expandableControllers!.length!=_costBloc.months!.length){
                _expandableControllers=_costBloc.months!.map((e) => ExpandableController()).toList();
              }
              if(_expandableControllers!=null){
                List<Month> months = _costBloc.months!;
                var typeCosts = _costBloc.typeCosts;
                var listCosts = _costBloc.listCosts;
                return SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      shrinkWrap: true,
                      physics: CustomScrollPhysics(
                          itemSize: width*0.8,
                          separatorSize: 5,
                          itemCount: months.length
                      ),
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) => GestureDetector(
                                  onTap: () {
                                    if (listCosts[months[index]] ==
                                        null) {
                                      _costBloc.add(CostListGetEvent(
                                          months[index]));
                                    }
                                    _expandableControllers![index].expanded =
                                    !_expandableControllers![index].expanded;
                                  },
                                  child: VisibilityDetector(
                                    onVisibilityChanged:
                                        (VisibilityInfo info) {
                                      if (info.visibleFraction * 100 > 50) {
                                        if (typeCosts[months[index]] ==
                                            null) {
                                          _costBloc.add(CostTypeGetEvent(
                                              months[index]));
                                        }
                                      }
                                    },
                                    key: Key("vd_key${months[index]}"),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                              index.isEven ? 5 : 0),
                                          child: ExpandableNotifier(
                                            controller:
                                            _expandableControllers![index],
                                            child: ExpandablePanel(
                                              collapsed: Container(
                                                width: width * 0.8,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(15)),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        months[index]
                                                            .getAsParameter(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "Manrope",
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            color: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color),
                                                      ),
                                                    ),
                                                    BlocBuilder<CostBloc,
                                                        CostState>(
                                                      bloc: _costBloc,
                                                      builder:
                                                          (context, state) {
                                                        if (typeCosts[months[
                                                        index]] !=
                                                            null) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top:
                                                                10.0),
                                                            child: TypeCostChart(
                                                                costs: typeCosts[
                                                                months[
                                                                index]]!),
                                                          );
                                                        }
                                                        return Padding(
                                                          padding: EdgeInsets.only(top:10),
                                                          child: Column(
                                                            children: [
                                                              SkeletonAvatar(
                                                                style: SkeletonAvatarStyle(
                                                                  height: width*0.33,
                                                                  width: width*0.33,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:10.0),
                                                                child: Wrap(
                                                                  direction: Axis.horizontal,
                                                                  runSpacing: 5,
                                                                  spacing: 10,
                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.2,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.1,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.15,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.05,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.3,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.2,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              expanded: Container(
                                                width: width * 0.8,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(15)),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        months[index]
                                                            .getAsParameter(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "Manrope",
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            color: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color),
                                                      ),
                                                    ),
                                                    BlocBuilder<CostBloc,
                                                        CostState>(
                                                      bloc: _costBloc,
                                                      builder: (context,
                                                          state) {
                                                        if (typeCosts[months[
                                                        index]] !=
                                                            null) {
                                                          return Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top:
                                                                10.0),
                                                            child: TypeCostChart(
                                                                costs: typeCosts[
                                                                months[
                                                                index]]!),
                                                          );
                                                        }
                                                        return Padding(
                                                          padding: EdgeInsets.only(top:10),
                                                          child: Column(
                                                            children: [
                                                              SkeletonAvatar(
                                                                style: SkeletonAvatarStyle(
                                                                  height: width*0.33,
                                                                  width: width*0.33,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:10.0),
                                                                child: Wrap(
                                                                  direction: Axis.horizontal,
                                                                  runSpacing: 5,
                                                                  spacing: 10,
                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.2,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.1,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.15,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.05,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding:EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          color: Theme.of(context).canvasColor,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                              width: width*0.3,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                width: width*0.2,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    BlocBuilder<CostBloc,
                                                        CostState>(
                                                      bloc: _costBloc,
                                                      builder: (context,
                                                          state) {
                                                        if (typeCosts[months[
                                                        index]] !=
                                                            null &&
                                                            listCosts[months[
                                                            index]] !=
                                                                null) {
                                                          return LayoutBuilder(
                                                              builder: (context,constrs) {
                                                                return Container(
                                                                  padding: EdgeInsets.only(top:10),
                                                                  constraints: BoxConstraints(
                                                                      maxHeight: height*0.33
                                                                  ),
                                                                  child: CustomScrollView(
                                                                    physics:
                                                                    BouncingScrollPhysics(),
                                                                    shrinkWrap:
                                                                    true,
                                                                    slivers: [
                                                                      SliverList(
                                                                          delegate: SliverChildBuilderDelegate(
                                                                                  (context, listIndex) => listCosts[months[index]]![listIndex].getAsWidget(context, _costBloc),
                                                                              childCount: listCosts[months[index]]!.length))
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                          );
                                                        }
                                                        return Container(
                                                          padding: EdgeInsets.only(top:10),
                                                          constraints: BoxConstraints(
                                                              maxHeight: height*0.33
                                                          ),
                                                          child: CustomScrollView(
                                                            physics: BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                        (context, index) => Container(
                                                                      margin: EdgeInsets.only(top: 10),
                                                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          color: Theme.of(context).canvasColor),
                                                                      child: Column(
                                                                        children: [
                                                                          SkeletonLine(
                                                                            style: SkeletonLineStyle(
                                                                                height: 10,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                width: width*0.15
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                            child: SkeletonLine(
                                                                              style: SkeletonLineStyle(
                                                                                  height: 10,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  width: width*0.1
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SkeletonLine(
                                                                                style: SkeletonLineStyle(
                                                                                    height: 10,
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    width: width*0.4
                                                                                ),
                                                                              ),
                                                                              SkeletonLine(
                                                                                style: SkeletonLineStyle(
                                                                                    height: 10,
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    width: width*0.12
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    childCount: 4
                                                                ),),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                childCount: months.length)
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return Container(
              margin: EdgeInsets.all(10),
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  shrinkWrap: true,
                  physics: CustomScrollPhysics(
                      itemSize: width*0.8,
                      separatorSize: 5,
                      itemCount: 2,
                  ),
                  slivers: [
                    SliverList(delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                index.isEven ? 5 : 0),
                            child: Container(
                              width: width*0.8,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  borderRadius:
                                  BorderRadius
                                      .circular(15)),
                              child: SkeletonLine(
                                style: SkeletonLineStyle(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 15,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      childCount: 2
                    ))
                  ],
                )
            );
          }),
    );
  }
}
