// To parse this JSON data, do
//
//     final addsModel = addsModelFromJson(jsonString);

import 'dart:convert';

AddsModel addsModelFromJson(String str) => AddsModel.fromJson(json.decode(str));

String addsModelToJson(AddsModel data) => json.encode(data.toJson());

class AddsModel {
  AddsModel({
    this.status,
    this.message,
   required this.data,
  });

  String? status;
  String? message;
  List<Datum> data;

  factory AddsModel.fromJson(Map<String, dynamic> json) => AddsModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.description,
    this.image,
    this.displayOrder,
    this.imagePath,
  });

  String? id;
  String? title;
  String? description;
  String? image;
  String? displayOrder;
  String? imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    displayOrder: json["display_order"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "display_order": displayOrder,
    "image_path": imagePath,
  };
}
