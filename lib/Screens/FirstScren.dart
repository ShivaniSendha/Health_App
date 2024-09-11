import 'package:flutter/material.dart';
import 'package:health_app/Component/CustomComponent/CustomButton.dart';
import 'package:health_app/utills/routes.dart';

class Firstscren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width and height to make it responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      child: Center(
        // Ensure the whole content is centered
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              SizedBox(height: screenHeight * 0.05), // Responsive spacing
              Image.asset(
                'assets/images/docters.png',
                height: screenHeight * 0.3, // Responsive image height
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Adds responsive space between the image and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: "Login",
                    icon: Icons.arrow_circle_right,
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoute.LoginRoute);
                    },
                  ),
                  CustomButton(
                    text: "Create Profile",
                    icon: Icons.arrow_circle_right,
                    onPressed: () {
                      Navigator.pushNamed(context, MyRoute.RegistrationRoute);
                    },
                  )
                ],
              ),
              SizedBox(
                  height: screenHeight *
                      0.05), // Adds responsive space below buttons
            ],
          ),
        ),
      ),
    );
  }
}
