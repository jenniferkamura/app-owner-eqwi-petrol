// To parse this JSON data, do
//
//     final notificationsListModel = notificationsListModelFromJson(jsonString);

import 'dart:convert';

NotificationsListModel notificationsListModelFromJson(String str) => NotificationsListModel.fromJson(json.decode(str));

String notificationsListModelToJson(NotificationsListModel data) => json.encode(data.toJson());

class NotificationsListModel {
  NotificationsListModel({
    this.pagesCount,
    this.totalRecordsCount,
    required this.result,
  });

  int? pagesCount;
  int? totalRecordsCount;
 final List<Result> result;

  factory NotificationsListModel.fromJson(Map<String, dynamic> json) => NotificationsListModel(
    pagesCount: json["pages_count"],
    totalRecordsCount: json["total_records_count"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages_count": pagesCount,
    "total_records_count": totalRecordsCount,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.title,
    this.message,
    this.dateTime,
    this.displayTime,
  });

  String? id;
  String? title;
  String? message;
  String? dateTime;
  String? displayTime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    dateTime: json["date_time"],
    displayTime: json["display_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "date_time": dateTime,
    "display_time": displayTime,
  };
}
