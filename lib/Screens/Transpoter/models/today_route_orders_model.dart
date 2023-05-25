// To parse this JSON data, do
//
//     final todayOrdersModelModel = todayOrdersModelModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TodayOrdersModelModel todayOrdersModelModelFromJson(String str) => TodayOrdersModelModel.fromJson(json.decode(str));

String todayOrdersModelModelToJson(TodayOrdersModelModel data) => json.encode(data.toJson());

class TodayOrdersModelModel {
  TodayOrdersModelModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory TodayOrdersModelModel.fromJson(Map<String, dynamic> json) => TodayOrdersModelModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<Datum>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.orderId,
    required this.transporterId,
    required this.stationId,
    required this.pickupData,
    required this.stationData,
    required this.assignStatus,
    required this.status,
    required this.assignDatetime,
    required this.orderNo,
    required this.paymentType,
    required this.isScheduleDelivery,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.timeLeftToAccept,
    required this.displayTime,
  });

  String id;
  String orderId;
  String transporterId;
  String stationId;
  PickupData pickupData;
  StationData stationData;
  String assignStatus;
  String status;
  String assignDatetime;
  String orderNo;
  String paymentType;
  String isScheduleDelivery;
  String deliveryDate;
  String deliveryTime;
  String timeLeftToAccept;
  int displayTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderId: json["order_id"],
    transporterId: json["transporter_id"],
    stationId: json["station_id"],
    pickupData: PickupData.fromJson(json["pickup_data"]),
    stationData: StationData.fromJson(json["station_data"]),
    assignStatus: json["assign_status"],
    status: json["status"],
    assignDatetime: json["assign_datetime"],
    orderNo: json["order_no"],
    paymentType: json["payment_type"],
    isScheduleDelivery: json["is_schedule_delivery"],
    deliveryDate: json["delivery_date"],
    deliveryTime: json["delivery_time"],
    timeLeftToAccept: json["time_left_to_accept"],
    displayTime: json["display_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "transporter_id": transporterId,
    "station_id": stationId,
    "pickup_data": pickupData.toJson(),
    "station_data": stationData.toJson(),
    "assign_status": assignStatus,
    "status": status,
    "assign_datetime": assignDatetime,
    "order_no": orderNo,
    "payment_type": paymentType,
    "is_schedule_delivery": isScheduleDelivery,
    // "delivery_date": "${deliveryDate.toString()}-${deliveryDate.toString()}-${deliveryDate.toString()}",
    "delivery_date": deliveryDate,
    "delivery_time": deliveryTime,
    "time_left_to_accept": timeLeftToAccept,
    "display_time": displayTime,
  };
}

class PickupData {
  PickupData({
    required this.address,
    required this.contactNo,
    required this.latitude,
    required this.longitude,
  });

  String address;
  String contactNo;
  String latitude;
  String longitude;

  factory PickupData.fromJson(Map<String, dynamic> json) => PickupData(
    address: json["address"],
    contactNo: json["contact_no"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "contact_no": contactNo,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class StationData {
  StationData({
    required this.stationId,
    required this.ownerId,
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
    required this.geoFencingAddress,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });

  String stationId;
  String ownerId;
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
  dynamic geoFencingAddress;
  String status;
  DateTime createdDate;
  dynamic updatedDate;

  factory StationData.fromJson(Map<String, dynamic> json) => StationData(
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
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: json["updated_date"],
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
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate,
  };
}
