import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './provider/history_provider.dart';
import './provider/score.dart';
import './screens/homepage.dart';
import './screens/history.dart';
void main(){
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[ChangeNotifierProvider.value(
        value:HistoryData(),),
        ChangeNotifierProvider.value(
          value:Score(), 
        ),
      ],
          child: MaterialApp(

        theme:ThemeData(
          primaryColor: Colors.green,
          secondaryHeaderColor: Colors.deepOrange,
        ),
        home: HomePage(),
        routes: {
          HomePage.routeName:(ctx)=>HomePage(),
          History.routeName:(ctx)=>const History(),
        },
      ),
    );
  }
}