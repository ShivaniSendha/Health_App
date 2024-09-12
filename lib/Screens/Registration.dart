// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';

class Registration extends StatefulWidget {
  static const String KEYLOGIN = 'login';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _profileImage;

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Method to register and save user details
  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      var sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('name', _nameController.text);
      await sharedPref.setString('email', _emailController.text);
      await sharedPref.setString('address', _addressController.text);
      // Save the profile image path
      if (_profileImage != null) {
        await sharedPref.setString('profilePhotoUrl', _profileImage!.path);
      }
      await sharedPref.setBool(Registration.KEYLOGIN, true);
      Navigator.pushNamed(context, MyRoute.LoginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Create Account'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture and upload button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],

                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null, // No image provider
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt,
                            size: 30,
                            color: Colors.grey) // Icon when no profile image
                        : null,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      'Upload Profile Picture',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
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
                    bottomLeft:
                        Radius.circular(40.0), // Rounded top-right corner
                  ),
                  // Border color and width
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name input field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Name",
                            labelText: "Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validateName,
                        ),
                        SizedBox(height: 20),

                        // Email field with custom validation
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your Email",
                            labelText: "Email",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validateEmail,
                        ),
                        SizedBox(height: 20),

                        // Password field with custom validation
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your Password",
                            labelText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validatePassword,
                        ),
                        SizedBox(height: 20),

                        // Address field with custom validation
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your Address",
                            labelText: "Address",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validateAddress,
                        ),
                        SizedBox(height: 20),

                        // Custom Button for form submission
                        CustomButton(
                          text: "Submit",
                          icon: Icons.arrow_circle_right,
                          onPressed: () {
                            _register(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
