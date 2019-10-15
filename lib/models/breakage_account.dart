import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

BreakageAccount activityFromJson(String str) {
  final jsonData = json.decode(str);
  return BreakageAccount.fromJson(jsonData);
}

String breakageToJson(BreakageAccount data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class BreakageAccount {
  String id;
  String employee_id;
  String company_id;
  double account;
  String status;
  String date;

  BreakageAccount(
      {this.id,
      this.employee_id,
      this.company_id,
      this.account,
      this.status,
      this.date});

  factory BreakageAccount.fromJson(Map<String, dynamic> json) =>
      new BreakageAccount(
          id: json["id"],
          employee_id: json["employee_id"],
          company_id: json["company_id"],
          account: json["account"],
          status: json["status"],
          date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "company_id": company_id,
        "account": account,
        "status": status,
        "date": date
      };

  factory BreakageAccount.fromDocument(DocumentSnapshot doc) {
    return BreakageAccount.fromJson(doc.data);
  }
}
