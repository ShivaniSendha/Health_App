// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
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
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size
    final responsiveFontSize = screenWidth * 0.045;

    return GestureDetector(
      onTap: widget.onPressed, 
      child: Container(
        width: double.infinity,
        height: 45, 
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        decoration: BoxDecoration(
          //Gradient Color
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 197, 176, 231), 
              Color.fromARGB(255, 113, 189, 202), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), // Rounded top-right corner
            bottomLeft: Radius.circular(40.0), // Rounded bottom-left corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.textColor, size: responsiveFontSize),
              SizedBox(width: screenWidth * 0.02),
            ],
            Text(
              widget.text,
              style: TextStyle(fontSize: responsiveFontSize, color: widget.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
