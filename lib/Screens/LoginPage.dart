// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';
import 'package:health_app/Screens/Registration.dart';
import 'package:health_app/utills/routes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> checkAuth() async {
    try {
      bool isDeviceSupported = await auth.isDeviceSupported();
      print("Is device supported for biometrics: $isDeviceSupported");

      bool canCheckBiometrics = await auth.canCheckBiometrics;
      print("Can check biometrics: $canCheckBiometrics");

      if (isDeviceSupported && canCheckBiometrics) {
        bool authenticated = await auth.authenticate(
          localizedReason: "Please authenticate to log in",
          // options: AuthenticationOptions(
          //   biometricOnly: true,
          // ),//This is Optional
        );
        if (authenticated) {
          print("Authentication successful");
          Navigator.pushNamed(context, MyRoute.HomeRoutes);
        } else {
          print("Authentication failed or canceled");
        }
      } else {
        print("Biometrics not supported or not available");
      }
    } catch (e) {
      print("An error occurred during authentication: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final imageHeight = screenHeight * 0.35; // Height of the image

    // Calculate the available height for the container
    final containerHeight = screenHeight - appBarHeight - imageHeight;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Login'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/health.avif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 100, 235, 194), // Start color
                    Color.fromARGB(255, 150, 94, 247), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0), // Rounded top-left corner
                  bottomLeft: Radius.circular(40.0), // Rounded top-right corner
                ),
                // Border color and width
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email input field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Please Enter Email",
                      labelText: "Email",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                    ),
                    validator: CustomValidator.validateEmail,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Password input field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Please Enter Password",
                      labelText: "Password",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                    ),
                    validator: CustomValidator.validatePassword,
                    obscureText: true, // Secure password input
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Custom Button
                  CustomButton(
                    text: "Login",
                    icon: Icons.arrow_circle_right,
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoute.HomeRoutes);
                    },
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        checkAuth();
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/fingerprint1.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
