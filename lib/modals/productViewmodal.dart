// To parse this JSON data, do
//
//     final productViewmodel = productViewmodelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProductViewmodel productViewmodelFromJson(String str) =>
    ProductViewmodel.fromJson(json.decode(str));

String productViewmodelToJson(ProductViewmodel data) =>
    json.encode(data.toJson());

class ProductViewmodel {
  ProductViewmodel({
    required this.categoryId,
    required this.name,
    required this.type,
    required this.image,
    required this.measurement,
    required this.status,
    required this.displayOrder,
    required this.createdDate,
    required this.updatedDate,
    required this.imagePath,
    required this.price,
    required this.currency,
  });

  String categoryId;
  String name;
  String type;
  String image;
  String measurement;
  String status;
  String displayOrder;
  DateTime createdDate;
  DateTime updatedDate;
  String imagePath;
  String price;
  String currency;

  factory ProductViewmodel.fromJson(Map<String, dynamic> json) =>
      ProductViewmodel(
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        measurement: json["measurement"],
        status: json["status"],
        displayOrder: json["display_order"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
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
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "image_path": imagePath,
        "price": price,
        "currency": currency,
      };
}
