import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickgrocerydelivery/localization/languages.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account_otp.dart';
import 'package:quickgrocerydelivery/screens/auth/otp.dart';
import 'package:quickgrocerydelivery/screens/auth/signin.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_main.dart';
import 'package:quickgrocerydelivery/screens/dashboard/setLocation.dart';
import 'package:quickgrocerydelivery/screens/onboarding/guidelines.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     
      locale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(buttonColor: Color(0xff33D1DB)),
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
      case '/dashboardMain':
        return PageTransition(
            child: DashboardMain(), type: PageTransitionType.leftToRight);

      case '/setLocation':
        return PageTransition(
            child: SetLocation(), type: PageTransitionType.leftToRight);

      default:
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
    }
  }
}
