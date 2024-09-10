// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_app/utills/routes.dart';

class Firstscren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers the content vertically

          children: [
            Positioned(
              top: 20,
              right: 40,
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 103, 22, 243),
                ),
              ),
            ),

            SizedBox(height: 20), // Adds space between the text and the image
            Image.asset(
              'assets/images/docters.png',
              // Specify height for better layout
            ),
            SizedBox(
                height: 40), // Adds space between the image and the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 103, 22, 243)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(130, 45))),
                    onPressed: () {
                      Navigator.pushNamed(context,
                          MyRoute.LoginRoute); // Navigate to LoginPage
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 103, 22, 243)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(Size(130, 45))),
                  onPressed: () {},
                  child: Text(
                    "Sign Up ",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
