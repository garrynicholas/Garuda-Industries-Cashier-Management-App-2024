import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/button.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/Views/login.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Authentication",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Text(
                "Autentikasi untuk akses vital informasi anda.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CircleAvatar(
                backgroundColor: primaryColor,
                radius: 107,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/garuda2.png"),
                  radius: 105,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Button(
                  label: "LOGIN",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
