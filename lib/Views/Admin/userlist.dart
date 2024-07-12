import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:garuda_industries/Views/Admin/updateuser.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<Users> users = [];
  late List<Users> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Fetch user data from the database
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Users> userList = await dbHelper.getAllUsers();
    setState(() {
      users = userList;
      filteredUsers = userList;
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.fullName!.toLowerCase().contains(query.toLowerCase()) ||
              user.NomorTelepon.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.Alamat!.toLowerCase().contains(query.toLowerCase()) ||
              user.usrName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showOptions(BuildContext context, Users user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserPage(user: user),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
              title: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _deleteUser(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context, Users user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            "Delete User",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this user?",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                DatabaseHelper dbHelper = DatabaseHelper();
                int result = await dbHelper.deleteUser(user.usrId!);
                // if user success to delete (return not equal to 0)
                if (result != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("User deleted successfully"),
                    ),
                  );
                  // Refresh the user list after deletion
                  fetchData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete user"),
                    ),
                  );
                }
              },
              child: Text(
                "Delete",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        Navigator.of(context).pop(); // Dismiss the bottom sheet
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterUsers(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Cari',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Cari berdasarkan nama, nomor telepon, alamat....',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      'UserID: ${user.usrId.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Full Name: ${user.fullName ?? ''}'),
                        SizedBox(height: 2),
                        Text('Phone Number: ${user.NomorTelepon ?? ''}'),
                        SizedBox(height: 2),
                        Text('Address: ${user.Alamat ?? ''}'),
                        SizedBox(height: 2),
                        Text('Username: ${user.usrName ?? ''}'),
                        SizedBox(height: 4),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        _showOptions(context, user);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
