import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

EmployeeNum employeeNumFromJson(String str) {
  final jsonData = json.decode(str);
  return EmployeeNum.fromJson(jsonData);
}

String employeeNumToJson(EmployeeNum data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class EmployeeNum {
  String id;
  String employee_id;
  String company_id;
  int status;
  String date;

  EmployeeNum(
      {this.id, this.employee_id, this.company_id, this.status, this.date});

  factory EmployeeNum.fromJson(Map<String, dynamic> json) => new EmployeeNum(
      id: json["id"],
      employee_id: json["employee_id"],
      company_id: json["company_id"],
      status: json["status"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "company_id": company_id,
        "status": status,
        "date": date
      };

  factory EmployeeNum.fromDocument(DocumentSnapshot doc) {
    return EmployeeNum.fromJson(doc.data);
  }
}
