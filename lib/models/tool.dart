import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Tool activityFromJson(String str) {
  final jsonData = json.decode(str);
  return Tool.fromJson(jsonData);
}

String breakageToJson(Tool data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Tool {
  String id;
  String company_id;
  String name;
  String description;
  double finePrice;
  String date;

  Tool(
      {this.id,
      this.company_id,
      this.name,
      this.description,
      this.finePrice,
      this.date});

  factory Tool.fromJson(Map<String, dynamic> json) => new Tool(
      id: json["id"],
      company_id: json["company_id"],
      name: json["name"],
      description: json["description"],
      finePrice: json["finePrice"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": company_id,
        "name": name,
        "description": description,
        "finePrice": finePrice,
        "date": date
      };

  factory Tool.fromDocument(DocumentSnapshot doc) {
    return Tool.fromJson(doc.data);
  }
}
