import '../../common/constants.dart';
import '../../common/utils.dart';
import '../../data/models/data_model.dart';
import '../../presentation/pages/about_page.dart';
import '../../presentation/pages/add_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/detail_page.dart';
import '../../presentation/provider/detail_page_notifier.dart';
import '../../presentation/provider/home_page_notifier.dart';
import '../../presentation/provider/add_page_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<DetailPageNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<HomePageNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<AddPageNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case DetailPage.ROUTE_NAME:
              final data = settings.arguments as DataItem;
              return CupertinoPageRoute(builder: (_) => DetailPage(data: data,));
            case AddPage.ROUTE_NAME:
              List<dynamic> args = settings.arguments as List<dynamic>;
              return CupertinoPageRoute(builder: (_) => AddPage(data: args[0],title: args[1],));
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
