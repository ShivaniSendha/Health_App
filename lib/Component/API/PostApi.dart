import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Postapi extends StatefulWidget {
  @override
  State<Postapi> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Postapi> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _avatarController = TextEditingController();

  Map<String, dynamic>? responseData;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POST API Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _avatarController,
              decoration: InputDecoration(labelText: 'Avatar URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: postData,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (responseData != null) ...[
              Text(
                "Name: ${responseData!['first_name']} ${responseData!['last_name']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Email: ${responseData!['email']}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Avatar: ${responseData!['avatar']}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void postData() async {
    const url = 'https://reqres.in/api/users'; // POST URL
    final uri = Uri.parse(url);

    // Collect data from text fields
    final email = _emailController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final avatar = _avatarController.text;

    // Define the body data for the POST request
    final bodyData = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar
    };

    // Make the POST request with the body data
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"}, // Headers (optional)
      body: jsonEncode(bodyData), // Convert the bodyData map to JSON
    );

    if (response.statusCode == 201) {
      // If the server returns a successful response
      final responseBody = response.body;
      final json = jsonDecode(responseBody);

      setState(() {
        responseData = json; // Store the response data
      });

      print('Post successful: $json');
    } else {
      print('Failed to post data: ${response.statusCode}');
    }
  }
}
