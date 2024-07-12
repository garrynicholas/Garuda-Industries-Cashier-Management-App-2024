// In profile.dart

import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/button.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Views/Admin/adminhome.dart';
import 'package:garuda_industries/Views/Cashier/cashierhome.dart';
import 'package:garuda_industries/Views/login.dart';

class RoleNavigator extends StatelessWidget {
  final Users? profile;

  const RoleNavigator({Key? key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Role",
              style: TextStyle(
                color: primaryColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Button(
              label: "Admin Home",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHome(
                      profile: profile,
                      selectedIndex: 0,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Button(
              label: "Cashier Home",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CashierHome(
                      profile: profile,
                      selectedIndex: 0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
