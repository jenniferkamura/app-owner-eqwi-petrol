// To parse this JSON data, do
//
//     final raiseTicketModel = raiseTicketModelFromJson(jsonString);

import 'dart:convert';

RaiseTicketModel raiseTicketModelFromJson(String str) => RaiseTicketModel.fromJson(json.decode(str));

String raiseTicketModelToJson(RaiseTicketModel data) => json.encode(data.toJson());

class RaiseTicketModel {
  RaiseTicketModel({
   required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  String data;

  factory RaiseTicketModel.fromJson(Map<String, dynamic> json) => RaiseTicketModel(
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
