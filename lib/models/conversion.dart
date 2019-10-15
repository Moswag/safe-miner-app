import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Conversion activityFromJson(String str) {
  final jsonData = json.decode(str);
  return Conversion.fromJson(jsonData);
}

String breakageToJson(Conversion data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Conversion {
  String id;
  String metal;
  String price;
  String date;

  Conversion({this.id, this.metal, this.price, this.date});

  factory Conversion.fromJson(Map<String, dynamic> json) => new Conversion(
      id: json["id"],
      metal: json["company_id"],
      price: json["from"],
      date: json["date"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "metal": metal, "price": price, "date": date};

  factory Conversion.fromDocument(DocumentSnapshot doc) {
    return Conversion.fromJson(doc.data);
  }
}
