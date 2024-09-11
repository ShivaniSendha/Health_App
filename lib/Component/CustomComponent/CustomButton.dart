// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color.fromARGB(255, 103, 22, 243),
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.width = 150,
    this.height = 50,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final responsiveWidth = screenWidth * 0.4; // 
    final responsiveHeight = screenHeight * 0.07; 
    final responsiveFontSize =
        screenWidth * 0.045;

    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: responsiveFontSize),
            SizedBox(width: screenWidth * 0.02), 
          ],
          Text(
            text,
            style: TextStyle(fontSize: responsiveFontSize, color: textColor),
          ),
        ],
      ),
      style: ButtonStyle(
        minimumSize:
            MaterialStateProperty.all(Size(responsiveWidth, responsiveHeight)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
      onPressed: onPressed,
    );
  }
}
