// ignore_for_file: prefer_const_constructors

import 'dart:io'; // Required for FileImage
import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/Screens/Profile/EditProfile.dart'; // Ensure this import is correct
import 'package:shared_preferences/shared_preferences.dart';

class ShowUserprofile extends StatefulWidget {
  const ShowUserprofile({Key? key}) : super(key: key);

  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<ShowUserprofile> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _contact = '';
  String _dob = '';
  String _gender = '';
  String _bloodGroup = '';
  String? _profilePhotoUrl; 
  bool _isEditing = false; 

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload profile data when the screen is resumed
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _firstName = sharedPref.getString('firstName') ?? 'N/A';
      _lastName = sharedPref.getString('lastName') ?? 'N/A';
      _email = sharedPref.getString('email') ?? 'N/A';
      _contact = sharedPref.getString('contact') ?? 'N/A';
      _dob = sharedPref.getString('dob') ?? 'N/A';
      _gender = sharedPref.getString('gender') ?? 'N/A';
      _bloodGroup = sharedPref.getString('bloodGroup') ?? 'N/A';
      _profilePhotoUrl = sharedPref.getString('profilePhotoUrl');
    });
  }

  Future<void> _logout() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _editProfile() {
    setState(() {
      _isEditing = true; // Set to edit mode
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfile()), // Navigate to EditProfile
    ).then((_) {
      // Reload the user profile and update state after returning from EditProfile
      setState(() {
        _isEditing = false; // Reset to view mode after editing
      });
      _loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05;
    final double avatarSize = screenWidth * 0.25;
    final double fontSize = screenWidth * 0.04;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _profilePhotoUrl != null
                    ? CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundImage: _profilePhotoUrl!.startsWith('http')
                            ? NetworkImage(_profilePhotoUrl!)
                            : FileImage(File(_profilePhotoUrl!))
                                as ImageProvider,
                      )
                    : CircleAvatar(
                        radius: avatarSize / 2,
                        child: Icon(Icons.person, size: avatarSize / 2),
                        backgroundColor: Colors.grey[300],
                      ),
                SizedBox(width: padding),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(padding),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.contacts_sharp, size: fontSize),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _firstName + " " + _lastName,
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.email, size: fontSize),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _email,
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Offstage(
              offstage:
                  _isEditing, // If _isEditing is true, the container will be hidden
              child: Container(
                margin: EdgeInsets.all(screenWidth * 0.02),
                padding: EdgeInsets.all(screenWidth * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, size: 20),
                        SizedBox(width: 6),
                        Text(
                          '$_contact',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, size: 20),
                        SizedBox(width: 6),
                        Text(
                          '$_dob',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.male_sharp, size: 20),
                        SizedBox(width: 6),
                        Text(
                          '$_gender',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.bloodtype, size: 20),
                        SizedBox(width: 6),
                        Text(
                          '$_bloodGroup',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Edit Profile",
                    icon: Icons.create,
                    onPressed: _editProfile,
                  ),
                ),
                SizedBox(width: padding),
                Expanded(
                  child: CustomButton(
                    text: "Logout",
                    icon: Icons.logout,
                    onPressed: _logout,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
