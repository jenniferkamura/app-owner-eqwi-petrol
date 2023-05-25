// To parse this JSON data, do
//
//     final getCompartmentModel = getCompartmentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetCompartmentModel getCompartmentModelFromJson(String str) => GetCompartmentModel.fromJson(json.decode(str));

String getCompartmentModelToJson(GetCompartmentModel data) => json.encode(data.toJson());

class GetCompartmentModel {
  GetCompartmentModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory GetCompartmentModel.fromJson(Map<String, dynamic> json) => GetCompartmentModel(
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
    required this.compartmentNo,
    required this.compartmentCapacity,
  });

  String compartmentNo;
  String compartmentCapacity;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    compartmentNo: json["compartment_no"],
    compartmentCapacity: json["compartment_capacity"],
  );

  Map<String, dynamic> toJson() => {
    "compartment_no": compartmentNo,
    "compartment_capacity": compartmentCapacity,
  };
}
