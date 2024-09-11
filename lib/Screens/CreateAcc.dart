// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';
import 'package:health_app/utills/routes.dart';

class CreateAcc extends StatefulWidget {
  @override
  _CreateAccState createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _phoneController =
      TextEditingController(); // Controller for phone input

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Customappbar(
        title: 'Mobile Number',
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
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
                  scale: 1,
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
                     Color.fromARGB(255, 100, 235, 194),// Start color
                    Color.fromARGB(255, 150, 94, 247), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), // Background color
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
                    // Changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Please Enter Your Phone Number",
                      labelText: "Phone",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                    ),
                    validator: CustomValidators.validatePhoneNumber,
                  ),
                  SizedBox(height: screenHeight * 0.03), // Responsive spacing
                  Center(
                    child: CustomButton(
                      text: "Send OTP",
                      icon: (Icons.arrow_circle_right),
                      onPressed: () {
                        validator:
                        CustomValidators.validatePhoneNumber;
                        Navigator.pushNamed(context, MyRoute.OTPRoute);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Responsive spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
