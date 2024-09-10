import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Component/Documents/HealthDocuments.dart';
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
      backgroundColor: const Color.fromARGB(255, 160, 96, 233),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          child: Column(
            children: [
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
      appBar: AppBar(
        title: Center(child: Text('Welcome')),
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
          SizedBox(width: 20),
        ],
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
                        color: Colors.deepPurple,
                        size: screenWidth * 0.06,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Text(
                        'Upload Document',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          
                          color: Colors.deepPurple,
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
                        color: Colors.deepPurple,
                        size: screenWidth * 0.06,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Text(
                        'Health Document',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.deepPurple,
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
        backgroundColor: Colors.deepPurple,
        color: Colors.deepPurple.shade200,
        items: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.settings_accessibility, color: Colors.white),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 160, 96, 233),
          content: Container(
            height: 130,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Userprofile()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
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
