// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Screens/Documents/HealthDocuments.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'Userprofile.dart'; // Import the Userprofile page

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> imgList = [
    Image.asset('assets/images/health1.jpg', fit: BoxFit.cover),
    Image.asset('assets/images/health2.webp', fit: BoxFit.cover),
    Image.asset('assets/images/health3.png', fit: BoxFit.cover),
    Image.asset('assets/images/health4.jpg', fit: BoxFit.cover),
  ];

  List<Map<String, dynamic>> _documents = [];
  String? _profilePhotoUrl; // To store the profile photo URL

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _documents.add({
          'name': result.files.single.name,
          'path': result.files.single.path!,
          'type': result.files.single.extension!,
          'date': DateTime.now().toString(),
        });
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _documents.add({
          'name': pickedFile.name,
          'path': pickedFile.path,
          'type': 'jpg',
          'date': DateTime.now().toString(),
        });
      });
    }
  }

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 100, 235, 194), // Start color
                Color.fromARGB(255, 150, 94, 247), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_present),
                title: Text('File'),
                onTap: () {
                  _pickDocument();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUploadedDocuments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: _documents.isNotEmpty
              ? ListView.builder(
                  itemCount: _documents.length,
                  itemBuilder: (context, index) {
                    final doc = _documents[index];
                    return ListTile(
                      leading: Icon(
                        (doc['type'] ?? '') == 'pdf'
                            ? Icons.insert_drive_file
                            : (doc['type'] == 'png' || doc['type'] == 'jpg')
                                ? Icons.image
                                : Icons.help_outline,
                      ),
                      title: Text('Document: ${doc['name']}'),
                      subtitle: Text('Uploaded on: ${doc['date']}'),
                    );
                  },
                )
              : Center(
                  child: Text('There is no document uploaded right now'),
                ),
        );
      },
    );
  }

  Future<void> _logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    // Navigate to login screen or initial screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _getProfilePhoto() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _profilePhotoUrl = sharedPref.getString('profilePhotoUrl');
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfilePhoto(); // Fetch the profile photo URL when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text("Care"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 100, 235, 194), // Start color
                  Color.fromARGB(255, 150, 94, 247), // End color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors
              .transparent, // Make background transparent to show gradient
          elevation: 0, // Optional: remove shadow for cleaner look

          actions: [
            CircleAvatar(
              backgroundImage: _profilePhotoUrl != null
                  ? FileImage(File(_profilePhotoUrl!))
                  : AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  _showProfileMenu(context);
                },
              ),
            ),
            SizedBox(width: 30),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image Slider
          CarouselSlider(
            options: CarouselOptions(
              height: screenHeight * 0.35,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1.0,
              enlargeCenterPage: true,
            ),
            items: imgList
                .map((item) => Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: item,
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: screenHeight * 0.03),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  _showBottomModal(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: const Color.fromARGB(255, 63, 143, 63),
                        size: screenWidth * 0.10,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Text(
                        'Upload Document',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromARGB(255, 63, 143, 63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HealthDocuments(uploadedDocuments: _documents),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        color: const Color.fromARGB(255, 63, 143, 63),
                        size: screenWidth * 0.10,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Text(
                        'Health Document',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromARGB(255, 63, 143, 63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors
            .transparent, // Make the background transparent to show gradient
        color: Color.fromARGB(255, 101, 218, 179), // Color of the active item
        buttonBackgroundColor: Colors.green, // Color of the button
        items: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.settings_accessibility, color: Colors.white),
        ],
        onTap: (index) {
          // Handle the navigation here
        },
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 100, 235, 194), // Start color
                  Color.fromARGB(255, 150, 94, 247), // End color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Userprofile(), // Navigate to the UserProfile page
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    _logout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
