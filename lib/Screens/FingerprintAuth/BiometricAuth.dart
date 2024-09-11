import 'package:flutter/material.dart';
import 'package:health_app/utills/routes.dart';
import 'package:local_auth/local_auth.dart';

class Biometricauth extends StatefulWidget {
  const Biometricauth({super.key});

  @override
  State<Biometricauth> createState() => _MyBiometricauthState();
}

class _MyBiometricauthState extends State<Biometricauth> {
  final LocalAuthentication auth = LocalAuthentication();
  Future<void> checkAuth() async {
    try {
      bool isBiomtricAvailable = await auth.canCheckBiometrics;
      print("Biometric Availability: $isBiomtricAvailable");
      if (isBiomtricAvailable) {
        bool result = await auth.authenticate(
          localizedReason: "Scan your fingerprint to proceed",
          // options: AuthenticationOptions(biometricOnly: true),
        );
        if (result) {
          print("Authentication Successfull");
          Navigator.pushNamed(context, MyRoute.HomeRoutes);
        } else {
          print("Authentication faild or cancelled");
        }
      } else {
        print("no biometric sensor");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biometric Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/biometric.gif'),
            SizedBox(height: 20),
            Text("Autenticating ...."),
            SizedBox(height: 20),
            ElevatedButton(onPressed: checkAuth, child: Text("Fingerprint"))
          ],
        ),
      ),
    );
  }
}
