import 'package:flutter/material.dart';
import 'package:health_app/Component/CreateAcc.dart';
import 'package:health_app/Component/FirstScren.dart';
import 'package:health_app/Component/Home.dart';
import 'package:health_app/Component/LoginPage.dart';
import 'package:health_app/Component/OtpScreen.dart';
import 'package:health_app/Component/Registration.dart';
import 'package:health_app/Component/SplashScreen.dart';
import 'package:health_app/Component/UserProfile.dart';
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
        // Remove parameters from here and manage them inside the StatefulWidget
        // MyRoutes.UploaaddocumentsRoutes: (context) => Uploaddocument(),
        // MyRoutes.HealthdocumentsRoutes: (context) => Healthdocuments(),
      },
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(primarySwatch: Colors.red),
    );
  }
}
