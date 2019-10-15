import 'package:cloud_firestore/cloud_firestore.dart';

class Survey {
  String id;
  String employeeId;
  String name;
  String title;
  String description;
  String imageUrl;
  String dateCreated;

  Survey(
      {this.id,
      this.employeeId,
      this.name,
      this.title,
      this.imageUrl,
      this.description,
      this.dateCreated});

  factory Survey.fromJson(Map<String, dynamic> json) => new Survey(
      id: json["id"],
      employeeId: json["employeeId"],
      name: json["name"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      description: json["description"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "name": name,
        "title": title,
        "imageUrl": imageUrl,
        "description": description,
        "dateCreated": dateCreated
      };

  factory Survey.fromDocument(DocumentSnapshot doc) {
    return Survey.fromJson(doc.data);
  }
}
