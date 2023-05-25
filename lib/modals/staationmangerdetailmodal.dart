// To parse this JSON data, do
//
//     final mangerdetails = mangerdetailsFromJson(jsonString);

import 'dart:convert';

Mangerdetails mangerdetailsFromJson(String str) =>
    Mangerdetails.fromJson(json.decode(str));

String mangerdetailsToJson(Mangerdetails data) => json.encode(data.toJson());

class Mangerdetails {
  Mangerdetails({
    this.status,
    this.message,
    this.data,
  });

  final String? status;
  final String? message;
  final Data? data;

  factory Mangerdetails.fromJson(Map<String, dynamic> json) => Mangerdetails(
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
    this.userId,
    this.loginId,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.stationId,
    this.latitude,
    this.longitude,
    this.profilePic,
    this.userToken,
    this.userType,
    this.stationCount,
  });

  final String? userId;
  final String? loginId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;
  final String? stationId;
  final String? latitude;
  final String? longitude;
  final String? profilePic;
  final String? userToken;
  final String? userType;
  final int? stationCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        loginId: json["login_id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        stationId: json["station_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        profilePic: json["profile_pic"],
        userToken: json["user_token"],
        userType: json["user_type"],
        stationCount: json["station_count"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "login_id": loginId,
        "name": name,
        "email": email,
        "mobile": mobile,
        "address": address,
        "station_id": stationId,
        "latitude": latitude,
        "longitude": longitude,
        "profile_pic": profilePic,
        "user_token": userToken,
        "user_type": userType,
        "station_count": stationCount,
      };
}
