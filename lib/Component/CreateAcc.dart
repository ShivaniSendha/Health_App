// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text("Create Account"),
        backgroundColor: Color.fromARGB(255, 103, 22, 243),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% of screen width for padding
            vertical: screenHeight * 0.02, // 2% of screen height for padding
          ),
          child: Form(
            key: _formKey, // Assign form key to the Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _phoneController, // Attach controller
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: "Please Enter Your Mobile No.",
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null; // No error
                  },
                ),
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Center(
                  child: ElevatedButton(
                    child: Text(
                      "Send OTP",
                      style: TextStyle(
                          color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed to the OTP screen
                        Navigator.pushNamed(context, MyRoute.OTPRoute);
                      }
                    },
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
                        Size(screenWidth * 0.5,
                            screenHeight * 0.06), // Responsive button size
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // Responsive spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
