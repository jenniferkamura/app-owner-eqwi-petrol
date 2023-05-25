import 'dart:convert';

TransporterAvailModel transporterAvailModelFromJson(String str) => TransporterAvailModel.fromJson(json.decode(str));

String transporterAvailModelToJson(TransporterAvailModel data) => json.encode(data.toJson());

class TransporterAvailModel {
  TransporterAvailModel({
    required this.userId,
    required this.loginId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.stationId,
    required this.latitude,
    required this.longitude,
    required this.profilePic,
    required this.userToken,
    required this.userType,
    required this.transporterAvailable,
    required this.profilePicUrl,
  });

  final String userId;
  final String loginId;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String stationId;
  final String latitude;
  final String longitude;
  final String? profilePic;
  final String? userToken;
  final String? userType;
  final bool transporterAvailable;
  final String? profilePicUrl;

  factory TransporterAvailModel.fromJson(Map<String, dynamic> json) => TransporterAvailModel(
    userId: json["user_id"],
    loginId: json["login_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    stationId: json["station_id"],
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
    profilePic: json["profile_pic"],
    userToken: json["user_token"],
    userType: json["user_type"],
    transporterAvailable: json["transporter_available"] == 1,
    profilePicUrl: json["profile_pic_url"],
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
    "transporter_available": transporterAvailable,
    "profile_pic_url": profilePicUrl,
  };
}
