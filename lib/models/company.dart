import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Company discoveryFromJson(String str) {
  final jsonData = json.decode(str);
  return Company.fromJson(jsonData);
}

String discoveryToJson(Company data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Company {
  String id;
  String name;
  String mission;
  String date;

  Company({this.id, this.name, this.mission, this.date});

  factory Company.fromJson(Map<String, dynamic> json) => new Company(
      id: json["id"],
      name: json["name"],
      mission: json["mission"],
      date: json["date"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "mission": mission, "date": date};

  factory Company.fromDocument(DocumentSnapshot doc) {
    return Company.fromJson(doc.data);
  }
}
