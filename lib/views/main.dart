import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:driver_diary/blocs/auth/auth_bloc.dart';
import 'package:driver_diary/blocs/cost/cost_bloc.dart';
import 'package:driver_diary/blocs/login_validation/login_validation_bloc.dart';
import 'package:driver_diary/blocs/map/map_bloc.dart';
import 'package:driver_diary/blocs/news/news_bloc.dart';
import 'package:driver_diary/blocs/note/note_bloc.dart';
import 'package:driver_diary/blocs/note_indicator/note_indicator_bloc.dart';
import 'package:driver_diary/blocs/page/page_bloc.dart';
import 'package:driver_diary/blocs/personal/personal_bloc.dart';
import 'package:driver_diary/blocs/redirect/redirect_bloc.dart';
import 'package:driver_diary/blocs/registration_validation/registration_validation_bloc.dart';
import 'package:driver_diary/blocs/stomp/stomp_bloc.dart';
import 'package:driver_diary/blocs/theme/theme_bloc.dart';
import 'package:driver_diary/blocs/vehicle/vehicle_bloc.dart';
import 'package:driver_diary/views/loading_page.dart';
import 'package:driver_diary/views/personal_page.dart';
import 'package:driver_diary/widgets/bars.dart';
import 'package:driver_diary/widgets/router_and_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'costs_page.dart';
import 'map_page.dart';
import 'news_page.dart';
import 'note_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(CheckAuthEvent())),
        BlocProvider<LoginValidationBloc>(
            create: (context) => LoginValidationBloc()),
        BlocProvider<RegistrationValidationBloc>(
            create: (context) => RegistrationValidationBloc()),
        BlocProvider<PageBloc>(create: (context) => PageBloc()),
        BlocProvider<RedirectBloc>(create: (context) => RedirectBloc()),
        BlocProvider<MapBloc>(create: (context) => MapBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<StompBloc>(create: (context) => StompBloc()),
        BlocProvider<NoteIndicatorBloc>(
            create: (context) => NoteIndicatorBloc()),
        BlocProvider<PersonalBloc>(create: (context) => PersonalBloc()),
        BlocProvider<VehicleBloc>(create: (context) => VehicleBloc()),
        BlocProvider<NewsBloc>(create: (context) => NewsBloc()),
        BlocProvider<CostBloc>(create: (context) => CostBloc()),
        BlocProvider<NoteBloc>(create: (context) => NoteBloc()),
      ],
      child: SkeletonTheme(
        shimmerGradient: LinearGradient(colors: [
          Color.fromRGBO(196, 196, 196, 0.5),
          Color.fromRGBO(100, 100, 100, 0.5),
        ]),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'Flutter Demo',
              themeMode: BlocProvider.of<ThemeBloc>(context).mode,
              darkTheme: ThemeData(
                  backgroundColor: Color.fromRGBO(34, 34, 38, 1),
                  primaryColor: Color.fromRGBO(51, 51, 54, 1),
                  canvasColor: Color.fromRGBO(196, 196, 196, 0.5),
                  fontFamily: "Manrope",
                  textTheme: TextTheme(
                      bodyText1: TextStyle(color: Colors.white),
                      bodyText2:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
                      button: TextStyle(color: Color.fromRGBO(34, 34, 38, 1))),
                  elevatedButtonTheme:
                      ElevatedButtonThemeData(style: ButtonStyle())),
              theme: ThemeData(
                  backgroundColor: Colors.white,
                  primaryColor: Color.fromRGBO(229, 229, 229, 1),
                  canvasColor: Color.fromRGBO(196, 196, 196, 0.5),
                  fontFamily: "Manrope",
                  textTheme: TextTheme(
                      bodyText1: TextStyle(color: Colors.black),
                      bodyText2:
                          TextStyle(color: Color.fromRGBO(68, 68, 68, 1)),
                      button:
                          TextStyle(color: Color.fromRGBO(196, 196, 196, 1))),
                  elevatedButtonTheme:
                      ElevatedButtonThemeData(style: ButtonStyle())),
              home: BlocRouter(),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      BlocProvider.of<PageBloc>(context).add(ChangePageEvent(0));
    });
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<PageBloc, PageState>(
      listener: (context, state) {
        if (state is PageChangedState && _pageController.hasClients) {
          _pageController.jumpToPage(state.pageIndex);
        }
      },
      builder: (context, state) {
        if (state is PageChangedState) {
          return DefaultTabController(
            length: state.tabsCount,
            initialIndex: 0,
            child: Scaffold(
              appBar: CustomBars(
                appBarValue: state.pageIndex,
              ),
              body: SafeArea(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    BlocProvider.of<PageBloc>(context)
                        .add(ChangePageEvent(page));
                  },
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  children: [
                    MapPage(),
                    CostPage(),
                    NotePage(),
                    NewsPage(),
                    PersonalPage(),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              bottomNavigationBar: AnimatedBottomNavigationBar(
                onTap: (index) => BlocProvider.of<PageBloc>(context)
                  ..add(ChangePageEvent(index)),
                icons: [
                  Icons.map_outlined,
                  Icons.attach_money_outlined,
                  Icons.text_snippet_outlined,
                  Icons.article_outlined,
                  Icons.person_outline
                ],
                backgroundColor: Theme.of(context).primaryColor,
                leftCornerRadius: 15,
                rightCornerRadius: 15,
                activeColor: Theme.of(context).textTheme.bodyText1!.color,
                inactiveColor: Color.fromRGBO(204, 204, 204, 1),
                activeIndex: state.pageIndex,
                gapLocation: GapLocation.none,
                notchMargin: 0,
              ),
            ),
          );
        }
        return LoadingPage();
      },
    );
  }
}
