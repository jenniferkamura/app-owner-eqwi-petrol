// To parse this JSON data, do
//
//     final deleteNotAvailableDates = deleteNotAvailableDatesFromJson(jsonString);

import 'dart:convert';

DeleteNotAvailableDates deleteNotAvailableDatesFromJson(String str) => DeleteNotAvailableDates.fromJson(json.decode(str));

String deleteNotAvailableDatesToJson(DeleteNotAvailableDates data) => json.encode(data.toJson());

class DeleteNotAvailableDates {
  DeleteNotAvailableDates({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory DeleteNotAvailableDates.fromJson(Map<String, dynamic> json) => DeleteNotAvailableDates(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
