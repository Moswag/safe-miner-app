import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Breakage activityFromJson(String str) {
  final jsonData = json.decode(str);
  return Breakage.fromJson(jsonData);
}

String breakageToJson(Breakage data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Breakage {
  String id;
  String employee_id;
  String company_id;
  String tool;
  String tool_id;
  String event;
  String status;
  String reason;
  String date;

  Breakage(
      {this.id,
      this.employee_id,
      this.company_id,
      this.tool,
      this.tool_id,
      this.event,
      this.status,
      this.reason,
      this.date});

  factory Breakage.fromJson(Map<String, dynamic> json) => new Breakage(
      id: json["id"],
      employee_id: json["employee_id"],
      company_id: json["company_id"],
      tool: json["tool"],
      tool_id: json["tool_id"],
      event: json["event"],
      status: json["status"],
      reason: json["reason"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "company_id": company_id,
        "tool": tool,
        "tool_id": tool_id,
        "event": event,
        "status": status,
        "reason": reason,
        "date": date
      };

  factory Breakage.fromDocument(DocumentSnapshot doc) {
    return Breakage.fromJson(doc.data);
  }
}
