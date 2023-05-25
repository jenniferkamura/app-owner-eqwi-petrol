// To parse this JSON data, do
//
//     final rejectReasonModel = rejectReasonModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RejectReasonModel rejectReasonModelFromJson(String str) => RejectReasonModel.fromJson(json.decode(str));

String rejectReasonModelToJson(RejectReasonModel data) => json.encode(data.toJson());

class RejectReasonModel {
  RejectReasonModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory RejectReasonModel.fromJson(Map<String, dynamic> json) => RejectReasonModel(
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
    required this.id,
    required this.title,
  });

  String id;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
