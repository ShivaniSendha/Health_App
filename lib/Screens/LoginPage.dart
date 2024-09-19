// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';
import 'package:health_app/utills/routes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatefulWidget {
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In Method

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Store user data in SharedPreferences
      if (user != null) {
        final sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString('email', user.email ?? 'N/A');
        await sharedPref.setString(
            'firstName', user.displayName?.split(' ').first ?? 'N/A');
        await sharedPref.setString(
            'lastName', user.displayName?.split(' ').last ?? 'N/A');
        await sharedPref.setString('profilePhotoUrl', user.photoURL ?? '');
      }

      return user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  // Google Sign-Out Method
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    print("User signed out of Google account");
  }

  Future<void> checkAuth() async {
    try {
      bool isDeviceSupported = await auth.isDeviceSupported();
      print("Is device supported for biometrics: $isDeviceSupported");

      bool checkBiometrics = await auth.canCheckBiometrics;
      print("Check biometrics: $checkBiometrics");

      if (isDeviceSupported && checkBiometrics) {
        bool authenticated = await auth.authenticate(
          localizedReason: "Please authenticate to log in",
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

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Login'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194),
          Color.fromARGB(255, 150, 94, 247),
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
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomButton(
                      text: "Login",
                      icon: Icons.arrow_circle_right,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(
                              context, MyRoute.CreateProfileRoutes);
                        }
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
                    SizedBox(height: screenHeight * 0.02),
                    // Google Sign-In Button
                    // Google Sign-In Button
                    CustomButton(
                      text: 'Sign in with Google',
                      icon: Icons.login,
                      onPressed: () async {
                        User? user = await signInWithGoogle();
                        if (user != null) {
                          // Save user details to SharedPreferences
                          final sharedPref =
                              await SharedPreferences.getInstance();
                          await sharedPref.setString('email', user.email ?? '');
                          await sharedPref.setString(
                              'displayName', user.displayName ?? '');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Signed in as ${user.displayName}')),
                          );
                          Navigator.pushNamed(context, MyRoute.HomeRoutes);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Google Sign-In failed')),
                          );
                        }
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    // CustomButton(
                    //   text: 'Sign out of Google',
                    //   icon: Icons.logout,
                    //   onPressed: () async {
                    //     await signOutGoogle();
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('User signed out')),
                    //     );
                    //   },
                    // ),
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
