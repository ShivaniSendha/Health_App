// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadDocumentButton extends StatelessWidget {
  final Function onTap;
  final double screenHeight;
  final double screenWidth;

  const UploadDocumentButton({
    required this.onTap,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 100, 235, 194), // Start color
              Color.fromARGB(255, 150, 94, 247), // End color
            ],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), // Rounded top-left corner
            bottomLeft: Radius.circular(40.0), // Rounded top-right corner
          ),
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
                fontSize: screenWidth * 0.055,
                color: const Color.fromARGB(255, 169, 216, 138),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
