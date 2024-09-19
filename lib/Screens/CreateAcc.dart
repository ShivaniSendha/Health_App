// ignore_for_file: prefer_const_constructors

import 'dart:developer'; // For logging errors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';
import 'package:health_app/Screens/Home.dart'; // Update to your actual Home page
import 'package:health_app/utills/routes.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class CreateAcc extends StatefulWidget {
  @override
  _CreateAccState createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Create Account'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194),
          Color.fromARGB(255, 150, 94, 247),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : SingleChildScrollView(
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
                          Color.fromARGB(255, 100, 235, 194),
                          Color.fromARGB(255, 150, 94, 247),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Your Email",
                              labelText: "Email",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 2),
                              ),
                            ),
                            validator: CustomValidator.validateEmail,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Your Password",
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 2),
                              ),
                            ),
                            validator: CustomValidator.validatePassword,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Center(
                            child: CustomButton(
                              text: "Verify",
                              icon: Icons.send,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;

                                  setState(() {
                                    _isLoading = true; // Show loading indicator
                                  });

                                  try {
                                    // Create user with email and password
                                    final UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );

                                    // Send email verification
                                    await userCredential.user
                                        ?.sendEmailVerification();

                                    // Save email and password to SharedPreferences
                                    final sharedPref =
                                        await SharedPreferences.getInstance();
                                    await sharedPref.setString(
                                        'userEmail', email);
                                    await sharedPref.setString(
                                        'userPassword', password);

                                    Fluttertoast.showToast(
                                      msg:
                                          'Verification email sent! Check your inbox.',
                                    );

                                    // Wait for 5 seconds
                                    await Future.delayed(Duration(seconds: 5));

                                    // Navigate to Home page
                                    Navigator.pushNamed(
                                        context,
                                        MyRoute
                                            .CreateProfileRoutes); // Update to your actual home page route
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                      msg: 'Email Already Exists..',
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    log("FirebaseAuthException: ${e.message}");
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg: 'Unexpected error: ${e.toString()}',
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    log("Unexpected error: ${e.toString()}");
                                  } finally {
                                    setState(() {
                                      _isLoading =
                                          false; // Hide loading indicator
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
