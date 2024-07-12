import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Views/Admin/Product/addproduct.dart';
import 'package:garuda_industries/Views/Admin/productlistpage.dart';
import 'package:garuda_industries/Views/Admin/purchaseorder.dart';
import 'package:garuda_industries/Views/Admin/salespage.dart';
import 'package:garuda_industries/Views/Admin/userlist.dart';
import 'package:garuda_industries/Views/profile.dart';
import 'package:garuda_industries/Views/Admin/signup.dart';

class AdminHome extends StatefulWidget {
  final Users? profile;
  final int selectedIndex;
  const AdminHome({Key? key, this.profile, required this.selectedIndex})
      : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navigate to AdminHome (Dashboard) page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdminHome(profile: widget.profile, selectedIndex: 0),
          ),
        );
      } else if (_selectedIndex == 1) {
        // Navigate to Cart page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(profile: widget.profile)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Admin Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 83, 83, 83),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!, ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.profile?.fullName ?? ''}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  DashboardButton(
                    icon: Icons.list,
                    label: "Product List",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ProductListPage())));
                    },
                  ),
                  DashboardButton(
                    icon: Icons.shopping_cart,
                    label: "Purchase Order",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  PurchaseOrder(profile: widget.profile))));
                    },
                  ),
                  DashboardButton(
                    icon: Icons.bar_chart,
                    label: "Sales Report",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SalesPage())));
                    },
                  ),
                  DashboardButton(
                    icon: Icons.person,
                    label: "Data User",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserListPage()));
                    },
                  ),
                  DashboardButton(
                    icon: Icons.add_box_rounded,
                    label: "Add Product",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProductPage()));
                    },
                  ),
                  DashboardButton(
                    icon: Icons.person_add,
                    label: "Add User",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
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
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const DashboardButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(4),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 12.0),
              child: Icon(icon, size: 50, color: backgroundColor),
            ),
            Expanded(child: Container()), // Spacer
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 18.0),
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
