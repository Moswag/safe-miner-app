import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SafetyRule safetyRuleFromJson(String str) {
  final jsonData = json.decode(str);
  return SafetyRule.fromJson(jsonData);
}

String discoveryToJson(SafetyRule data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SafetyRule {
  String id;
  String company_id;
  String rule;
  String description;
  String date;

  SafetyRule(
      {this.id, this.company_id, this.rule, this.description, this.date});

  factory SafetyRule.fromJson(Map<String, dynamic> json) => new SafetyRule(
      id: json["id"],
      company_id: json["company_id"],
      rule: json["rule"],
      description: json["description"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": company_id,
        "rule": rule,
        "description": description,
        "date": date
      };

  factory SafetyRule.fromDocument(DocumentSnapshot doc) {
    return SafetyRule.fromJson(doc.data);
  }
}
