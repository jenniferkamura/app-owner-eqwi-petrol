// To parse this JSON data, do
//
//     final signatureModel = signatureModelFromJson(jsonString);

import 'dart:convert';

SignatureModel signatureModelFromJson(String str) => SignatureModel.fromJson(json.decode(str));

String signatureModelToJson(SignatureModel data) => json.encode(data.toJson());

class SignatureModel {
  SignatureModel({
     this.image,
     this.imagePath,
  });

  String? image;
  String? imagePath;

  factory SignatureModel.fromJson(Map<String, dynamic> json) => SignatureModel(
    image: json["image"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "image_path": imagePath,
  };
}
