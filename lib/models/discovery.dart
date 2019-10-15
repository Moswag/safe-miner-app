import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Discovery discoveryFromJson(String str) {
  final jsonData = json.decode(str);
  return Discovery.fromJson(jsonData);
}

String discoveryToJson(Discovery data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Discovery {
  String id;
  String employee_id;
  String company_id;
  String title;
  String description;
  String image_url;
  String date;

  Discovery(
      {this.id,
      this.employee_id,
      this.company_id,
      this.title,
      this.description,
      this.image_url,
      this.date});

  factory Discovery.fromJson(Map<String, dynamic> json) => new Discovery(
      id: json["id"],
      employee_id: json["employee_id"],
      company_id: json["company_id"],
      title: json["title"],
      description: json["description"],
      image_url: json["image_url"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employee_id,
        "company_id": company_id,
        "title": title,
        "description": description,
        "image_url": image_url,
        "date": date
      };

  factory Discovery.fromDocument(DocumentSnapshot doc) {
    return Discovery.fromJson(doc.data);
  }
}
