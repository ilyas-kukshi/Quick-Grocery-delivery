import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickgrocerydelivery/screens/auth/signin.dart';
import 'package:quickgrocerydelivery/screens/onboarding/guidelines.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
        buttonColor: Color(0xff33D1DB),
        textTheme: TextTheme(
            headline1:
                TextStyle(color: Colors.black, fontFamily: 'Times New Roman'),
            headline2:
                TextStyle(color: Colors.white, fontFamily: 'Times New Roman'),
            headline3:
                TextStyle(color: Colors.black, fontFamily: 'Source Sans Pro'),
            headline4:
                TextStyle(color: Colors.white, fontFamily: 'Source Sans Pro')),
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: routing,
      home: Guidelines(),
    );
  }

  Route routing(RouteSettings settings) {
    switch (settings.name) {
      case '/signIn':
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
      default:
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
    }
  }
}
