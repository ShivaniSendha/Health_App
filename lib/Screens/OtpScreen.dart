import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';
import 'package:pinput/pinput.dart';

class Otpscreen extends StatefulWidget {
  final String verificationId;

  Otpscreen({required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<Otpscreen> {
  final _pinController =
      TextEditingController(); // Use this controller if needed

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.12, // Dynamically adjust width
      height: screenHeight * 0.07, // Dynamically adjust height
      textStyle: TextStyle(
        fontSize: screenWidth * 0.05, // Responsive font size for pin
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('OTP'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image at the top
            Container(
              width: double.infinity,
              height: screenHeight * 0.3, // Adjust height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/health.avif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Container for form elements
            Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 22, 243, 177), // Start color
                    Color.fromARGB(255, 169, 135, 228), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), // Background gradient
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0), // Rounded top-right corner
                  bottomLeft:
                      Radius.circular(40.0), // Rounded bottom-left corner
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Enter the code sent to your mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Pinput(
                    keyboardType: TextInputType.phone,
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.green),
                      ),
                    ),
                    onCompleted: (pin) async {
                      if (pin.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter the OTP");
                        return;
                      }

                      try {
                        final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: pin,
                        );

                        // Sign in the user with the OTP credential
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        Fluttertoast.showToast(msg: "Phone number verified");

                        // Navigate to home or any other screen
                        Navigator.pushNamed(context, MyRoute.HomeRoutes);
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Invalid OTP: ${e.toString()}");
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomButton(
                    text: "Verify OTP",
                    icon: Icons.verified_user_outlined,
                    onPressed: () {
                      final otp = _pinController.text.trim();
                      if (otp.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter the OTP");
                        return;
                      }

                      try {
                        final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otp,
                        );

                        // Sign in the user with the OTP credential
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((userCredential) {
                          Fluttertoast.showToast(msg: "Phone number verified");
                          Navigator.pushNamed(
                              context, MyRoute.CreateProfileRoutes);
                        }).catchError((e) {
                          Fluttertoast.showToast(
                              msg: "Invalid OTP: ${e.toString()}");
                        });
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Invalid OTP: ${e.toString()}");
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
