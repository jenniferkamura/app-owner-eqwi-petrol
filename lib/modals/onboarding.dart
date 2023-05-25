// To parse this JSON data, do
//
//     final onboardinglist = onboardinglistFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Onboardinglist onboardinglistFromJson(String str) =>
    Onboardinglist.fromJson(json.decode(str));

String onboardinglistToJson(Onboardinglist data) => json.encode(data.toJson());

class Onboardinglist {
  Onboardinglist({
    required this.sliderId,
    required this.title,
    required this.description,
    required this.image,
    required this.imagePath,
  });

  String sliderId;
  String title;
  String description;
  String image;
  String imagePath;

  factory Onboardinglist.fromJson(Map<String, dynamic> json) => Onboardinglist(
        sliderId: json["slider_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "slider_id": sliderId,
        "title": title,
        "description": description,
        "image": image,
        "image_path": imagePath,
      };
}
