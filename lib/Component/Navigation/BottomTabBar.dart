import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final Function(int) onTap;

  const BottomNavigationBarWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Color.fromARGB(255, 101, 218, 179),
      buttonBackgroundColor: Colors.green,
      items: [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.settings_accessibility, color: Colors.white),
      ],
      onTap: (index) => onTap(index),
    );
  }
}
