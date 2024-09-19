import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  File? _profileImage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  String? _selectedGender;
  String? _selectedBloodGroup;
  DateTime? _selectedDOB;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = sharedPref.getString('firstName') ?? '';
      _lastNameController.text = sharedPref.getString('lastName') ?? '';
      _emailController.text =
          sharedPref.getString('userEmail') ?? ''; // Updated key for email
      _contactController.text = sharedPref.getString('contact') ?? '';
      _dobController.text = sharedPref.getString('dob') ?? '';
      _selectedGender = sharedPref.getString('gender');
      _selectedBloodGroup = sharedPref.getString('bloodGroup');
      _profileImage = sharedPref.getString('profilePhotoUrl') != null
          ? File(sharedPref.getString('profilePhotoUrl')!)
          : null;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createProfile(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      var sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('firstName', _firstNameController.text);
      await sharedPref.setString('lastName', _lastNameController.text);
      await sharedPref.setString('email', _emailController.text);
      await sharedPref.setString('contact', _contactController.text);
      await sharedPref.setString('dob', _dobController.text);
      await sharedPref.setString('gender', _selectedGender ?? '');
      await sharedPref.setString('bloodGroup', _selectedBloodGroup ?? '');

      if (_profileImage != null) {
        await sharedPref.setString('profilePhotoUrl', _profileImage!.path);
      }

      Navigator.pushNamed(context, MyRoute.HomeRoutes);
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = _selectedDOB ?? currentDate;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _selectedDOB = pickedDate;
        _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Create Profile'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194),
          Color.fromARGB(255, 150, 94, 247),
        ],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, size: 30, color: Colors.grey)
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your First Name",
                            labelText: "First Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validateName,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your Last Name",
                            labelText: "Last Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          validator: CustomValidator.validateName,
                        ),
                        SizedBox(height: 20),
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
                          readOnly: true, // Make the email field read-only
                          validator: CustomValidator.validateEmail,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Enter Your Password",
                            labelText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          obscureText: true,
                          validator: CustomValidator.validatePassword,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Please Confirm Your Password",
                            labelText: "Confirm Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                      
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Create Profile',
                          onPressed: () => _createProfile(context),
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
