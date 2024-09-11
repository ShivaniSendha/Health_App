import 'package:flutter/material.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color> gradientColors;

  const Customappbar({
    Key? key,
    required this.title,
    this.gradientColors = const [
      Color.fromARGB(255, 22, 243, 177), // Default Start color
      Color.fromARGB(255, 150, 94, 247), // Default End color
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Make background transparent to show gradient
        elevation: 0, // Optional: remove shadow for a cleaner look
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
