// To parse this JSON data, do
//
//     final helpAndSupportModel = helpAndSupportModelFromJson(jsonString);

import 'dart:convert';

HelpAndSupportModel helpAndSupportModelFromJson(String str) => HelpAndSupportModel.fromJson(json.decode(str));

String helpAndSupportModelToJson(HelpAndSupportModel data) => json.encode(data.toJson());

class HelpAndSupportModel {
  HelpAndSupportModel({
    this.status,
    this.message,
   required this.data,
  });

  String? status;
  String? message;
 final List<Datum> data;

  factory HelpAndSupportModel.fromJson(Map<String, dynamic> json) => HelpAndSupportModel(
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
    this.question,
    this.answer,
    this.displayOrder,
  });

  String? id;
  String? question;
  String? answer;
  String? displayOrder;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    displayOrder: json["display_order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "display_order": displayOrder,
  };
}
