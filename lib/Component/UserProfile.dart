// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Color.fromARGB(255, 103, 22, 243),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.logout,
                    color: Colors.white), // Use the logout icon here
                label: Text("Logout"),
                onPressed: _logout, // Call the logout function
                style: ElevatedButton.styleFrom(
                  iconColor: Color.fromARGB(
                      255, 103, 22, 243), // Background color of the button
                  minimumSize: Size(200, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
