// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app/Component/Carousel.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:health_app/Component/HealthDocumentButton.dart';
import 'package:health_app/Component/Navigation/BottomTabBar.dart';
import 'package:health_app/Component/ProfileAvatar.dart';
import 'package:health_app/Component/UploadDocumentButton.dart';
import 'package:health_app/Screens/Documents/HealthDocuments.dart';

import 'package:health_app/utills/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _profilePhotoUrl;

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

        // Show toast message after document is added
        Fluttertoast.showToast(
          msg: "Document uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      // Handle the case where no document was selected or show an error toast
      Fluttertoast.showToast(
        msg: "No document selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
          'date': DateTime.now().toString(),
        });
        _documents.add({
          'name': pickedFile.name,
          'path': pickedFile.path,
          'type': 'png',
          'date': DateTime.now().toString(),
        });
      });
    }
  }

  Future<void> _getProfilePhoto() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _profilePhotoUrl = sharedPref.getString('profilePhotoUrl');
    });
  }

  Future<void> _logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
    // Navigate to login screen or initial screen
    Navigator.pushReplacementNamed(context, '/login');
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
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text(
                  'Camera',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_present),
                title: Text(
                  'File',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pushNamed(
                          context, MyRoute.ShowUserprofileRoutes);
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
        });
  }

  @override
  void initState() {
    super.initState();
    _getProfilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Care'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
        automaticallyImplyLeading: false,
        actions: [
          Profileavatar(
            profilePhotoUrl: _profilePhotoUrl,
            onPressed: () => _showProfileMenu(context),
          ),
          SizedBox(width: 30),
        ],
      ),
      body: Column(
        children: [
          Carousel(
            imgList: imgList,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.03),
          Column(
            children: [
              UploadDocumentButton(
                onTap: () => _showBottomModal(context),
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
              HealthDocumentsButton(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthDocuments(
                      uploadedDocuments: _documents,
                    ),
                  ),
                ),
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        onTap: (index) {
          // BottomTabBar navigation
        },
      ),
    );
  }
}
