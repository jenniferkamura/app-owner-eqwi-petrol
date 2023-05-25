// To parse this JSON data, do
//
//     final stationList = stationListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StationList stationListFromJson(String str) =>
    StationList.fromJson(json.decode(str));

String stationListToJson(StationList data) => json.encode(data.toJson());

class StationList {
  StationList({
    required this.stationId,
    required this.stationName,
    required this.contactPerson,
    required this.contactNumber,
    required this.alternateNumber,
    required this.country,
    required this.state,
    required this.city,
    required this.pincode,
    required this.landmark,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String stationId;
  String stationName;
  String contactPerson;
  String contactNumber;
  String alternateNumber;
  String country;
  String state;
  String city;
  String pincode;
  String landmark;
  String address;
  String latitude;
  String longitude;

  factory StationList.fromJson(Map<String, dynamic> json) => StationList(
        stationId: json["station_id"],
        stationName: json["station_name"],
        contactPerson: json["contact_person"],
        contactNumber: json["contact_number"],
        alternateNumber: json["alternate_number"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pincode: json["pincode"],
        landmark: json["landmark"],
        address: json["address"],
        latitude: json["latitude"] == null ? '' : json["latitude"],
        longitude: json["longitude"] == null ? '' : json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "station_id": stationId,
        "station_name": stationName,
        "contact_person": contactPerson,
        "contact_number": contactNumber,
        "alternate_number": alternateNumber,
        "country": country,
        "state": state,
        "city": city,
        "pincode": pincode,
        "landmark": landmark,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
