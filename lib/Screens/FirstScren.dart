import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';

class Firstscren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width and height to make it responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        // Ensure the whole content is centered
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Add padding for responsiveness
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centers horizontally
              children: [
                SizedBox(
                    height: screenHeight * 0.05), // Responsive vertical spacing
                Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight * 0.3, // Responsive image height
                  width: screenWidth * 0.8, // Responsive image width
                  fit: BoxFit.contain, // Ensures the image scales well
                ),
                SizedBox(
                    height: screenHeight *
                        0.05), // Responsive space between the image and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: CustomButton(
                          text: "Create Profile",
                          icon: Icons.arrow_right_alt,
                          onPressed: () {
                            Navigator.pushNamed(
                                context, MyRoute.CreateProfileRoutes);
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                    height:
                        screenHeight * 0.05), // Responsive space below buttons
              ],
            ),
          ),
        ),
      ),
    );
  }
}
