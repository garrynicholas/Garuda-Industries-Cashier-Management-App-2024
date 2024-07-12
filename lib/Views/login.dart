import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/button.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/Components/textfield.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:garuda_industries/Views/navigator.dart';
import 'package:garuda_industries/Views/profile.dart';
import 'package:garuda_industries/Views/refreshadmin.dart';
import 'package:garuda_industries/Views/refreshkasir.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Our controller
  // Controller is used to take the value from user and pass it  to database
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  // Login Method
  // This will take the value of text fields using controller in order to verify whether details are correct or not
  login() async {
    // Check if the developer user exists in the database
    bool isDeveloperUserExist = await db.checkUserExist("GARUDA-IDS-DEVELOPER");

    if (!isDeveloperUserExist) {
      // If the developer user doesn't exist, create it
      Users developerUser = Users(
        fullName: "Gunawan Widya Nugraha",
        NomorTelepon: 621234567,
        Alamat: "Pasuruan",
        usrName: "GARUDA-IDS-DEVELOPER",
        password: "gids",
      );
      await db.createUser(developerUser);
    }

    // get user details by username, assign the result back to usrDetails
    Users? usrDetails = await db.getUser(usrName.text.trim());

    // Check if the username and password match the developer credentials
    if (usrName.text.trim() == "GARUDA-IDS-DEVELOPER" &&
        password.text.trim() == "gids") {
      // Navigate to role selection page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoleNavigator(profile: usrDetails),
        ),
      );
      return;
    }

    // If the developer credentials are not used, proceed with normal login flow
    var res = await db.authenticate(
      Users(usrName: usrName.text.trim(), password: password.text.trim()),
    );

    if (res == true) {
      if (!mounted) return;
      // Check if the username contains "admin" or "kasir" (case insensitive)
      if (usrName.text.toLowerCase().contains("admin")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RefreshAdmin(profile: usrDetails),
          ),
        );
      } else if (usrName.text.toLowerCase().contains("kasir")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RefreshKasir(profile: usrDetails),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(profile: usrDetails),
          ),
        );
      }
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LOGIN",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
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
              InputField(
                  hint: "Username",
                  icon: Icons.account_circle,
                  controller: usrName),
              InputField(
                hint: "Password",
                icon: Icons.lock,
                controller: password,
              ),
              SizedBox(
                height: 16,
              ),
              Button(
                  label: "LOGIN",
                  press: () {
                    login();
                  }),

              // Access denied message in case when username and password is incorrect
              // By default we must hide it
              isLoginTrue
                  ? Text(
                      "Username or password is incorrect",
                      style: TextStyle(color: Colors.red.shade900),
                    )
                  : const SizedBox(),
            ],
          )),
        ),
      ),
    );
  }
}
