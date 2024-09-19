import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Component/API/ApiPractice.dart';
import 'package:health_app/Component/API/PostApi.dart';
import 'package:health_app/Screens/CreateAcc.dart';
import 'package:health_app/Screens/FirstScren.dart';
import 'package:health_app/Screens/Home.dart';

import 'package:health_app/Screens/LoginPage.dart';
import 'package:health_app/Screens/Profile/CreateProfile.dart';
import 'package:health_app/Screens/Profile/EditProfile.dart';
import 'package:health_app/Screens/Profile/UserProfile.dart';
import 'package:health_app/Screens/SplashScreen.dart';

import 'package:health_app/utills/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()); // Start app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoute.CreateAccRoute,
      routes: {
        MyRoute.HomeRoutes: (context) => Home(),
        MyRoute.LoginRoute: (context) => Loginpage(),
        MyRoute.SplashRoute: (context) => Splashscreen(),
        MyRoute.FirstscrenRoute: (context) => Firstscren(),
        MyRoute.CreateAccRoute: (context) => CreateAcc(),
        MyRoute.CreateProfileRoutes: (context) => CreateProfile(),
        MyRoute.EditProfileRoutes: (context) => EditProfile(),
        MyRoute.ShowUserprofileRoutes: (context) => ShowUserprofile(),
        MyRoute.Api: (context) => Apipractice(),
        MyRoute.Postapi: (context) => Postapi()
      },
    );
  }
}
