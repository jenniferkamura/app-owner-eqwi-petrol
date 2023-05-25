// To parse this JSON data, do
//
//     final transporterHomeModel = transporterHomeModelFromJson(jsonString);

import 'dart:convert';

TransporterHomeModel transporterHomeModelFromJson(String str) => TransporterHomeModel.fromJson(json.decode(str));

String transporterHomeModelToJson(TransporterHomeModel data) => json.encode(data.toJson());

class TransporterHomeModel {
  TransporterHomeModel({
    this.userId,
    this.loginId,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.stationId,
    this.mobileVerified,
    this.latitude,
    this.longitude,
    this.profilePic,
    this.userToken,
    this.userType,
    this.transporterAvailable,
    this.vehicleId,
    this.profilePicUrl,
    this.vehicleNumber,
    this.vehicleCapacity,
    this.unreadNotifications,
    this.cartCount,
    this.displayAdvertisement,
    required this.rating,
  });

  String? userId;
  String? loginId;
  String? name;
  String? email;
  String? mobile;
  String? address;
  String? stationId;
  String? mobileVerified;
  String? latitude;
  String? longitude;
  String? profilePic;
  String? userToken;
  String? userType;
  String? transporterAvailable;
  String? vehicleId;
  String? profilePicUrl;
  String? vehicleNumber;
  String? vehicleCapacity;
  int? unreadNotifications;
  int? cartCount;
  String? displayAdvertisement;
  String rating;

  factory TransporterHomeModel.fromJson(Map<String, dynamic> json) => TransporterHomeModel(
    userId: json["user_id"],
    loginId: json["login_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    stationId: json["station_id"],
    mobileVerified: json["mobile_verified"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    profilePic: json["profile_pic"],
    userToken: json["user_token"],
    userType: json["user_type"],
    transporterAvailable: json["transporter_available"].toString(),
    vehicleId: json["vehicle_id"],
    profilePicUrl: json["profile_pic_url"],
    vehicleNumber: json["vehicle_number"],
    vehicleCapacity: json["vehicle_capacity"],
    unreadNotifications: json["unread_notifications"],
    cartCount: json["cart_count"],
    displayAdvertisement: json["display_advertisement"],
    rating: json["rating"] ?? "0",
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "login_id": loginId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "address": address,
    "station_id": stationId,
    "mobile_verified": mobileVerified,
    "latitude": latitude,
    "longitude": longitude,
    "profile_pic": profilePic,
    "user_token": userToken,
    "user_type": userType,
    "transporter_available": transporterAvailable,
    "vehicle_id": vehicleId,
    "profile_pic_url": profilePicUrl,
    "vehicle_number": vehicleNumber,
    "vehicle_capacity": vehicleCapacity,
    "unread_notifications": unreadNotifications,
    "cart_count": cartCount,
    "display_advertisement": displayAdvertisement,
    "rating": rating,
  };
}
