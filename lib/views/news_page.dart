import 'package:driver_diary/blocs/news/news_bloc.dart';
import 'package:driver_diary/utils/msg_utils.dart';
import 'package:driver_diary/widgets/news_widget.dart';
import 'package:driver_diary/widgets/stomp_listener.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  final ExpandableController _expandableController=ExpandableController();
  @override
  Widget build(BuildContext context) {
    final _newsBloc = BlocProvider.of<NewsBloc>(context);
    if (_newsBloc.state is NewsInitial) {
      _newsBloc.add(GetNewsEvent());
    }
    return SafeArea(
      child: StompListener(
        child: Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          child: BlocConsumer<NewsBloc, NewsState>(listener: (cont, state) {
            if (state is NewsErrorState) {
              errorSnack(cont, state.errorMessage);
            }
            if(state is NewsSearchFilterChangedState){
              _newsBloc.add(GetNewsEvent());
            }
          }, builder: (cont, state) {
            if (_newsBloc.news != null) {
              return ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: _newsBloc.news!
                    .map((e) => NewsWidget(
                          title: e.title,
                          description: e.description,
                          imageLink: e.image,
                          prettyDate: e.prettyDate,
                          author: e.author,
                        ))
                    .toList(),
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
                      color: Theme.of(context).primaryColor),
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
      ),
    );
  }
}
