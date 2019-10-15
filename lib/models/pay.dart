import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Pay discoveryFromJson(String str) {
  final jsonData = json.decode(str);
  return Pay.fromJson(jsonData);
}

String discoveryToJson(Pay data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Pay {
  String id;
  String employee_id;
  String company_id;
  double pay;
  String date;

  Pay({this.id, this.employee_id, this.company_id, this.pay, this.date});

  factory Pay.fromJson(Map<String, dynamic> json) => new Pay(
      id: json["id"],
      employee_id: json["employee_id"],
      company_id: json["company_id"],
      pay: json["pay"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "company_id": company_id,
        "pay": pay,
        "date": date
      };

  factory Pay.fromDocument(DocumentSnapshot doc) {
    return Pay.fromJson(doc.data);
  }
}
