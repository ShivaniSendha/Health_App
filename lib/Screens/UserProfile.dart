// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({Key? key}) : super(key: key);

  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  String _name = '';
  String _email = '';
  String _address = '';
  String? _profilePhotoUrl; // To store the profile photo URL

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    var sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _name = sharedPref.getString('name') ?? 'N/A';
      _email = sharedPref.getString('email') ?? 'N/A';
      _address = sharedPref.getString('address') ?? 'N/A';
      _profilePhotoUrl = sharedPref.getString('profilePhotoUrl');
    });
  }

  Future<void> _logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text("User Profile"),
        gradientColors: [
          Color.fromARGB(255, 22, 243, 177), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
          automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_profilePhotoUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(_profilePhotoUrl!)),
              )
            else
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
                backgroundColor: Colors.grey[300],
              ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 100, 235, 194),// Start color
                    Color.fromARGB(255, 150, 94, 247), // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $_name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email: $_email',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Address: $_address',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: CustomButton(
                text: "Logout",
                icon: Icons.logout,
                onPressed: () {
                  _logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
