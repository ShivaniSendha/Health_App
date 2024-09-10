// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:health_app/utills/routes.dart';

import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 50,
        height: 50,
        textStyle: const TextStyle(fontSize: 22, color: Colors.black),
        decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent)));
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP"),
        backgroundColor: Color.fromARGB(255, 103, 22, 243),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "Verification",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Enter the code sent to your number",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  "+91 9755567836",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Pinput(
                  keyboardType: TextInputType.phone,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                  onCompleted: (pin) => debugPrint(pin),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoute.RegistrationRoute);
                  },
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 103, 22, 243),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(150, 45),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
