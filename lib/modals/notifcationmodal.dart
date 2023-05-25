// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
  });

  String id;
  String title;
  String message;
  String dateTime;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        dateTime: json["date_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "date_time": dateTime,
      };
}
