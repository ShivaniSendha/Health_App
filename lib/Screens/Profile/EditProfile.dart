import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/Component/CustomComponent/CustomAppbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';
import 'package:health_app/Component/CustomComponent/customTextFormValidation.dart';

class EditProfile extends StatefulWidget {
  static const String KEYLOGIN = 'login';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  File? _profileImage;

  // Gender and Blood Group options
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

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Method to editProfile and save user details
  Future<void> _editProfile(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      var sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('contact', _contactController.text);
      await sharedPref.setString('dob', _dobController.text);
      await sharedPref.setString('gender', _selectedGender ?? '');
      await sharedPref.setString('bloodGroup', _selectedBloodGroup ?? '');
      Navigator.pushNamed(context, MyRoute.ShowUserprofileRoutes);
    }
  }

  // Method to show date picker
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [],
        title: Text('Edit Profile'),
        gradientColors: [
          Color.fromARGB(255, 100, 235, 194), // Custom Start color
          Color.fromARGB(255, 150, 94, 247), // Custom End color
        ],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/health.avif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
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
                  topRight: Radius.circular(40.0), // Rounded top-right corner
                  bottomLeft:
                      Radius.circular(40.0), // Rounded bottom-left corner
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact field
                    TextFormField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Please Enter Your Contact Number",
                        labelText: "Contact",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      validator: CustomValidator.validateContact,
                    ),
                    SizedBox(height: 20),

                    // Date of Birth field with date picker
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Please Enter Your Date of Birth",
                        labelText: "Date of Birth",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDateOfBirth(context),
                      validator: CustomValidator.validateDOB,
                    ),
                    SizedBox(height: 20),

                    // Gender dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      hint: Text("Select Gender"),
                      items: _genders.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      validator: CustomValidator.validateGender,
                    ),
                    SizedBox(height: 20),

                    // Blood Group dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      hint: Text("Select Blood Group"),
                      items: _bloodGroups.map((bloodGroup) {
                        return DropdownMenuItem<String>(
                          value: bloodGroup,
                          child: Text(bloodGroup),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodGroup = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      validator: CustomValidator.validateBloodGroup,
                    ),
                    SizedBox(height: 20),

                    // Custom Button for form submission
                    CustomButton(
                      text: "Submit",
                      icon: Icons.arrow_circle_right,
                      onPressed: () {
                        _editProfile(
                            context); // Call _editProfile when the button is pressed
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
