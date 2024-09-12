import 'package:flutter/material.dart';
import 'package:health_app/Screens/CreateAcc.dart';
import 'package:health_app/Screens/FirstScren.dart';
import 'package:health_app/Screens/Home.dart';
import 'package:health_app/Screens/ListView.dart';
import 'package:health_app/Screens/LoginPage.dart';
import 'package:health_app/Screens/OtpScreen.dart';
import 'package:health_app/Screens/Registration.dart';
import 'package:health_app/Screens/SplashScreen.dart';
import 'package:health_app/Screens/Userprofile.dart';
import 'package:health_app/utills/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoute.SplashRoute,
      routes: {
        MyRoute.HomeRoutes: (context) => Home(),
        MyRoute.LoginRoute: (context) => Loginpage(),
        MyRoute.SplashRoute: (context) => Splashscreen(),
        MyRoute.FirstscrenRoute: (context) => Firstscren(),
        MyRoute.CreateAccRoute: (context) => CreateAcc(),
        MyRoute.OTPRoute: (context) => OtpScreen(),
        MyRoute.RegistrationRoute: (context) => Registration(),
        MyRoute.UserprofileRoutes: (context) => Userprofile(),
        MyRoute.ListviewRoutes: (context) => ListView()

        // MyRoutes.UploaaddocumentsRoutes: (context) => UpRloaddocument(),
        // MyRoutes.HealthdocumentsRoutes: (context) => Healthdocuments(),
      },
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(primarySwatch: Colors.red),
    );
  }
}
