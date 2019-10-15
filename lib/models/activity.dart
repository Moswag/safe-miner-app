import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Activity activityFromJson(String str) {
  final jsonData = json.decode(str);
  return Activity.fromJson(jsonData);
}

String activityToJson(Activity data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Activity {
  String id;
  String employee_id;
  String title;
  String description;
  int status;
  String date;

  Activity(
      {this.id,
      this.employee_id,
      this.title,
      this.description,
      this.status,
      this.date});

  factory Activity.fromJson(Map<String, dynamic> json) => new Activity(
      id: json["id"],
      employee_id: json["employee_id"],
      title: json["title"],
      description: json["description"],
      status: json["status"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "title": title,
        "description": description,
        "status": status,
        "date": date
      };

  factory Activity.fromDocument(DocumentSnapshot doc) {
    return Activity.fromJson(doc.data);
  }
}
