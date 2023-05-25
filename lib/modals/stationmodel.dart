// To parse this JSON data, do
//
//     final stationdetailsmodel = stationdetailsmodelFromJson(jsonString);

import 'dart:convert';

Stationdetailsmodel stationdetailsmodelFromJson(String str) =>
    Stationdetailsmodel.fromJson(json.decode(str));

String stationdetailsmodelToJson(Stationdetailsmodel data) =>
    json.encode(data.toJson());

class Stationdetailsmodel {
  Stationdetailsmodel({
    this.status,
    this.message,
    this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory Stationdetailsmodel.fromJson(Map<String, dynamic> json) =>
      Stationdetailsmodel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.stationId,
    this.ownerId,
    this.stationName,
    this.contactPerson,
    this.contactNumber,
    this.alternateNumber,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.landmark,
    this.address,
    this.latitude,
    this.longitude,
    this.geoFencingAddress,
    this.status,
    // this.createdDate,
    // this.updatedDate,
  });

  final String? stationId;
  final String? ownerId;
  final String? stationName;
  final String? contactPerson;
  final String? contactNumber;
  final String? alternateNumber;
  final String? country;
  final String? state;
  final String? city;
  final String? pincode;
  final String? landmark;
  final String? address;
  final String? latitude;
  final String? longitude;
  final dynamic geoFencingAddress;
  final String? status;
  // final DateTime createdDate;
  // final DateTime updatedDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stationId: json["station_id"],
        ownerId: json["owner_id"],
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
        latitude: json["latitude"],
        longitude: json["longitude"],
        geoFencingAddress: json["geo_fencing_address"],
        status: json["status"],
        // createdDate: DateTime.parse(json["created_date"]),
        // updatedDate: DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "station_id": stationId,
        "owner_id": ownerId,
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
        "geo_fencing_address": geoFencingAddress,
        "status": status,
        // "created_date": createdDate.toIso8601String(),
        // "updated_date": updatedDate.toIso8601String(),
      };
}
