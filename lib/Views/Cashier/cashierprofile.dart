import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Views/Cashier/cashierhome.dart';
import 'package:garuda_industries/Views/login.dart';

class CashierProfile extends StatefulWidget {
  final Users? profile;
  const CashierProfile({Key? key, this.profile}) : super(key: key);

  @override
  _CashierProfileState createState() => _CashierProfileState();
}

class _CashierProfileState extends State<CashierProfile> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navigate to AdminHome (Dashboard) page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CashierHome(
                    profile: widget.profile,
                    selectedIndex: 0,
                  )),
        );
      } else if (_selectedIndex == 1) {
        // Navigate to Cart page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CashierProfile(profile: widget.profile)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 67,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/garuda2.png"),
                    radius: 65,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.profile!.fullName ?? "",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.profile!.usrName ?? "",
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign out here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    widget.profile!.fullName ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    "Full Name",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    size: 30,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    widget.profile!.NomorTelepon.toString() ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home_filled,
                    size: 30,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    widget.profile!.Alamat ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    "Address",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    widget.profile!.usrName,
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    "Username [Level]",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color.fromARGB(136, 43, 43, 43),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
