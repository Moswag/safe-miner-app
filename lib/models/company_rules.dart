import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CompanyRule activityFromJson(String str) {
  final jsonData = json.decode(str);
  return CompanyRule.fromJson(jsonData);
}

String breakageToJson(CompanyRule data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CompanyRule {
  String id;
  String company_id;
  String title;
  String rule;
  String date;

  CompanyRule({this.id, this.company_id, this.title, this.rule, this.date});

  factory CompanyRule.fromJson(Map<String, dynamic> json) => new CompanyRule(
      id: json["id"],
      company_id: json["company_id"],
      title: json["title"],
      rule: json["rule"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": company_id,
        "title": title,
        "rule": rule,
        "date": date
      };

  factory CompanyRule.fromDocument(DocumentSnapshot doc) {
    return CompanyRule.fromJson(doc.data);
  }
}
