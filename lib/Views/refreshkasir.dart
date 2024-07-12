import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Views/Admin/adminhome.dart';
import 'package:garuda_industries/Views/Cashier/cashierhome.dart';

class RefreshKasir extends StatefulWidget {
  final Users? profile;

  const RefreshKasir({Key? key, this.profile}) : super(key: key);

  @override
  _RefreshKasirState createState() => _RefreshKasirState();
}

class _RefreshKasirState extends State<RefreshKasir> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds before navigating back to SalesPage
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CashierHome(profile: widget.profile, selectedIndex: 0),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // custom loading indicator
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                // This ensures that the progress indicator remains blue and doesn't change color during the animation
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Loading content...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
