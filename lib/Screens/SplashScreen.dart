// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:health_app/utills/routes.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to FirstScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, MyRoute.CreateAccRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/careslogen1.jpg",
              scale: 2,
            ),
            SizedBox(
              height: 30.0,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
