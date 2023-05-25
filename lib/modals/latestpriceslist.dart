// To parse this JSON data, do
//
//     final homescreenpriceslist = homescreenpriceslistFromJson(jsonString);

import 'dart:convert';

Homescreenpriceslist homescreenpriceslistFromJson(String str) =>
    Homescreenpriceslist.fromJson(json.decode(str));

String homescreenpriceslistToJson(Homescreenpriceslist data) =>
    json.encode(data.toJson());

class Homescreenpriceslist {
  Homescreenpriceslist({
    this.categoryId,
    this.name,
    this.type,
    this.image,
    this.measurement,
    this.status,
    this.displayOrder,
    this.imagePath,
    this.price,
    this.currency,
  });

  final String? categoryId;
  final String? name;
  final String? type;
  final String? image;
  final String? measurement;
  final String? status;
  final String? displayOrder;
  final String? imagePath;
  final String? price;
  final String? currency;

  factory Homescreenpriceslist.fromJson(Map<String, dynamic> json) =>
      Homescreenpriceslist(
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        measurement: json["measurement"],
        status: json["status"],
        displayOrder: json["display_order"],
        imagePath: json["image_path"],
        price: json["price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name": name,
        "type": type,
        "image": image,
        "measurement": measurement,
        "status": status,
        "display_order": displayOrder,
        "image_path": imagePath,
        "price": price,
        "currency": currency,
      };
}
