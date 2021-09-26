import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickgrocerydelivery/localization/languages.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account_otp.dart';
import 'package:quickgrocerydelivery/screens/auth/otp.dart';
import 'package:quickgrocerydelivery/screens/auth/signin.dart';
import 'package:quickgrocerydelivery/screens/onboarding/guidelines.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: Languages(),
      locale: Locale('en', 'US'),
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
      case '/createAccount':
        return PageTransition(
            child: CreateAccount(), type: PageTransitionType.leftToRight);
      case '/otp':
        return PageTransition(
            child: Otp(), type: PageTransitionType.leftToRight);

      case '/createAccountOtp':
        return PageTransition(
            child: CreateAccountOtp(), type: PageTransitionType.leftToRight);

      case '/createAccountOtp':
        return PageTransition(
            child: CreateAccountOtp(), type: PageTransitionType.leftToRight);

      default:
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
    }
  }
}
