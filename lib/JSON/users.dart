// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

// Decoding JSON means parsing a JSON string and converting it into a data structure that can be used in the programming language.
// Encoding JSON means converting a data structure from a programming language into its JSON representation as a string.

import 'package:meta/meta.dart';
import 'dart:convert';

// Users from Map convert json string into dart object
Users usersFromMap(String str) => Users.fromMap(json.decode(str));

// Users into Map convert dart object into json string
String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String? fullName;
  final int? NomorTelepon;
  final String? Alamat;
  final String usrName;
  final String password;

  Users({
    this.usrId,
    this.fullName,
    this.NomorTelepon,
    this.Alamat,
    required this.usrName,
    required this.password,
  });

  // parameter (json) is a map
  // (Map<String, dynamic> is declaring
  // this code is to create a instance of users class
  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        NomorTelepon: json["NomorTelepon"],
        Alamat: json["Alamat"],
        usrName: json["usrName"],
        password: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "fullName": fullName,
        "NomorTelepon": NomorTelepon,
        "Alamat": Alamat,
        "usrName": usrName,
        "usrPassword": password,
      };
}
