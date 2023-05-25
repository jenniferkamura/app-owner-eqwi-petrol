// To parse this JSON data, do
//
//     final deleteNotificationModel = deleteNotificationModelFromJson(jsonString);

import 'dart:convert';

DeleteNotificationModel deleteNotificationModelFromJson(String str) => DeleteNotificationModel.fromJson(json.decode(str));

String deleteNotificationModelToJson(DeleteNotificationModel data) => json.encode(data.toJson());

class DeleteNotificationModel {
  DeleteNotificationModel({
    required this.status,
    required this.message,
    required this.data,
  });

 final String status;
 final String message;
 final bool data;

  factory DeleteNotificationModel.fromJson(Map<String, dynamic> json) => DeleteNotificationModel(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
