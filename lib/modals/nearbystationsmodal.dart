// To parse this JSON data, do
//
//     final nearbyStationsmodal = nearbyStationsmodalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

NearbyStationsmodal nearbyStationsmodalFromJson(String str) =>
    NearbyStationsmodal.fromJson(json.decode(str));

String nearbyStationsmodalToJson(NearbyStationsmodal data) =>
    json.encode(data.toJson());

class NearbyStationsmodal {
  NearbyStationsmodal({
    required this.stationId,
    required this.stationName,
    required this.contactPerson,
    required this.contactNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String stationId;
  String stationName;
  String contactPerson;
  String contactNumber;
  String address;
  String latitude;
  String longitude;

  factory NearbyStationsmodal.fromJson(Map<String, dynamic> json) =>
      NearbyStationsmodal(
        stationId: json["station_id"] ?? '',
        stationName: json["station_name"] ?? '',
        contactPerson: json["contact_person"] ?? '',
        contactNumber: json["contact_number"] ?? '',
        address: json["address"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "station_id": stationId,
        "station_name": stationName,
        "contact_person": contactPerson,
        "contact_number": contactNumber,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
