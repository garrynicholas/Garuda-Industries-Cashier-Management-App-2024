import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/button.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/Components/textfield.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:garuda_industries/Views/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullName = TextEditingController();
  final NomorTelepon = TextEditingController();
  final Alamat = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();

  final db = DatabaseHelper();
  bool isUserExist = false;
  bool showMissingFieldWarning = false;

  signUp() async {
    // Check if any text field is empty
    if (fullName.text.isEmpty ||
        NomorTelepon.text.isEmpty ||
        Alamat.text.isEmpty ||
        usrName.text.isEmpty ||
        password.text.isEmpty) {
      setState(() {
        showMissingFieldWarning = true;
      });
      return;
    }

    bool usrExist = await db.checkUserExist(usrName.text);
    // If user exists, show the message
    if (usrExist) {
      setState(() {
        isUserExist = true;
      });
    } else {
      // otherwise create account
      // indicate +1 store to res if create user
      var res = await db.createUser(Users(
          fullName: fullName.text,
          // parse string into int
          NomorTelepon: int.tryParse(NomorTelepon.text),
          Alamat: Alamat.text,
          usrName: usrName.text,
          password: password.text));
      // if res greater than 0, send to loginscreen
      if (res > 0) {
        // If !mounted (meaning the widget is not mounted), the callback can avoid updating the UI or perform cleanup actions to prevent errors.
        // to prevent data login leaks
        if (!mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Register New Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                  hint: "Full Name", icon: Icons.person, controller: fullName),
              InputField(
                hint: "Phone Number",
                icon: Icons.phone,
                controller: NomorTelepon,
                isTextFieldNumber: true,
              ),
              InputField(
                  hint: "Address", icon: Icons.email, controller: Alamat),
              InputField(
                  hint: "Username",
                  icon: Icons.account_circle,
                  controller: usrName),
              InputField(
                hint: "Password",
                icon: Icons.lock,
                controller: password,
              ),

              const SizedBox(
                height: 20,
              ),
              Button(
                  label: "SIGN UP",
                  press: () {
                    signUp();
                  }),

              // End

              // Warning message for missing fields
              showMissingFieldWarning
                  ? const Text(
                      "Please fill out all fields",
                      style: TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),

              // Message when there is a duplicate user

              // By default, we hide the message
              isUserExist
                  ? const Text(
                      "User already exists, please enter another name",
                      style: TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
            ],
          )),
        ),
      ),
    );
  }
}
