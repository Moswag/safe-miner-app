import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String name;
  String phonenumber;
  String email;
  String role;
  String companyId;
  bool isEmployee;
  String employeeNumb;

  User(
      {this.userId,
      this.name,
      this.phonenumber,
      this.email,
      this.role,
      this.companyId,
      this.isEmployee,
      this.employeeNumb});

  factory User.fromJson(Map<String, dynamic> json) => new User(
      userId: json["userId"],
      name: json["name"],
      phonenumber: json["phonenumber"],
      email: json["email"],
      role: json["role"],
      companyId: json["companyId"],
      isEmployee: json["isEmployee"],
      employeeNumb: json["employeeNumb"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "phonenumber": phonenumber,
        "email": email,
        "role": role,
        "companyId": companyId,
        "isEmployee": isEmployee,
        "employeeNumb": employeeNumb
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
