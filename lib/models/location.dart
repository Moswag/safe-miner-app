import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Location locationFromJson(String str) {
  final jsonData = json.decode(str);
  return Location.fromJson(jsonData);
}

String locationToJson(Location data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Location {
  String id;
  String company_id;
  String side1_longitude;
  String side1_latitude;
  String side2_longitude;
  String side2_latitude;
  String side3_longitude;
  String side3_latitude;
  String side4_longitude;
  String side4_latitude;
  int status;
  String date;

  Location(
      {this.id,
      this.company_id,
      this.side1_longitude,
      this.side1_latitude,
      this.side2_longitude,
      this.side2_latitude,
      this.side3_longitude,
      this.side3_latitude,
      this.side4_longitude,
      this.side4_latitude,
      this.status,
      this.date});

  factory Location.fromJson(Map<String, dynamic> json) => new Location(
      id: json["id"],
      company_id: json["company_id"],
      side1_longitude: json["side1_longitude"],
      side1_latitude: json["side1_latitude"],
      side2_longitude: json["side2_longitude"],
      side2_latitude: json["side2_latitude"],
      side3_longitude: json["side3_longitude"],
      side3_latitude: json["side3_latitude"],
      side4_longitude: json["side4_longitude"],
      side4_latitude: json["side4_latitude"],
      status: json["status"],
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": company_id,
        "side1_longitude": side1_longitude,
        "side1_latitude": side1_latitude,
        "side2_longitude": side2_longitude,
        "side2_latitude": side2_latitude,
        "side3_longitude": side3_longitude,
        "side3_latitude": side3_latitude,
        "side4_longitude": side4_longitude,
        "side4_latitude": side4_latitude,
        "status": status,
        "date": date
      };

  factory Location.fromDocument(DocumentSnapshot doc) {
    return Location.fromJson(doc.data);
  }
}
