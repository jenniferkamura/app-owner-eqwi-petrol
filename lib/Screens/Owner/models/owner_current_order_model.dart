// To parse this JSON data, do
//
//     final ownerCurrentOrdersModel = ownerCurrentOrdersModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OwnerCurrentOrdersModel ownerCurrentOrdersModelFromJson(String str) =>
    OwnerCurrentOrdersModel.fromJson(json.decode(str));

String ownerCurrentOrdersModelToJson(OwnerCurrentOrdersModel data) =>
    json.encode(data.toJson());

class OwnerCurrentOrdersModel {
  OwnerCurrentOrdersModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.stationId,
    required this.shippingCharge,
    required this.tax,
    required this.amount,
    required this.totalAmount,
    required this.orderStatus,
    required this.isOwner,
    required this.orderDate,
    required this.isScheduleDelivery,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.paymentType,
    required this.status,
    required this.isOrder,
    // required this.createdDate,
    // required this.updatedDate,
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
    required this.productName,
    required this.geoFencingAddress,
  });

  final String id;
  final String userId;
  final String orderId;
  final String stationId;
  final String shippingCharge;
  final String tax;
  final String amount;
  final String totalAmount;
  final String orderStatus;
  final String isOwner;
  final DateTime orderDate;
  final String isScheduleDelivery;
  final DateTime deliveryDate;
  final String deliveryTime;
  final String paymentType;
  final String status;
  final String isOrder;
  // final DateTime createdDate;
  // final DateTime updatedDate;
  final String ownerId;
  final String stationName;
  final String contactPerson;
  final String contactNumber;
  final String alternateNumber;
  final String country;
  final String state;
  final String city;
  final String pincode;
  final String landmark;
  final String address;
  final String latitude;
  final String longitude;
  final String productName;
  final dynamic geoFencingAddress;

  factory OwnerCurrentOrdersModel.fromJson(Map<String, dynamic> json) =>
      OwnerCurrentOrdersModel(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        stationId: json["station_id"],
        shippingCharge: json["shipping_charge"],
        tax: json["tax"],
        amount: json["amount"],
        totalAmount: json["total_amount"],
        orderStatus: json["order_status"],
        isOwner: json["is_owner"],
        orderDate: DateTime.parse(json["order_date"]),
        isScheduleDelivery: json["is_schedule_delivery"],
        deliveryDate: DateTime.parse(json["delivery_date"]),
        deliveryTime: json["delivery_time"],
        paymentType: json["payment_type"],
        status: json["status"],
        isOrder: json["is_order"],
        // createdDate: DateTime.parse(json["created_date"]),
        // updatedDate: DateTime.parse(json["updated_date"]),
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
        productName: json["product_name"],
        geoFencingAddress: json["geo_fencing_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "station_id": stationId,
        "shipping_charge": shippingCharge,
        "tax": tax,
        "amount": amount,
        "total_amount": totalAmount,
        "order_status": orderStatus,
        "is_owner": isOwner,
        "order_date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "is_schedule_delivery": isScheduleDelivery,
        "delivery_date":
            "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "payment_type": paymentType,
        "status": status,
        "is_order": isOrder,
        // "created_date": createdDate.toIso8601String(),
        // "updated_date": updatedDate.toIso8601String(),
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
        "product_name": productName,
        "geo_fencing_address": geoFencingAddress,
      };
}
