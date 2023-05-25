
import 'package:meta/meta.dart';
import 'dart:convert';

TransportOrderListModel transportOrderListModelFromJson(String str) => TransportOrderListModel.fromJson(json.decode(str));

String transportOrderListModelToJson(TransportOrderListModel data) => json.encode(data.toJson());

class TransportOrderListModel {
  TransportOrderListModel({
    required this.pagesCount,
    required this.totalRecordsCount,
    required this.result,
  });

  final int pagesCount;
  final int totalRecordsCount;
  final List<Result> result;

  factory TransportOrderListModel.fromJson(Map<String, dynamic> json) => TransportOrderListModel(
    pagesCount: json["pages_count"],
    totalRecordsCount: json["total_records_count"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages_count": pagesCount,
    "total_records_count": totalRecordsCount,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.orderId,
    required this.vendorId,
    required this.transporterId,
    required this.stationId,
    required this.vendorData,
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
    required  this.displayTime,

  });

  final String id;
  final String orderId;
  final String vendorId;
  final String transporterId;
  final String stationId;
  final VendorData vendorData;
  final StationData stationData;
  final String assignStatus;
  final String status;
   String? assignDatetime;
  final String orderNo;
  final String paymentType;
  final String isScheduleDelivery;
  final String deliveryDate;
  final String deliveryTime;
  String timeLeftToAccept;
  final DateTime? displayTime;


  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    orderId: json["order_id"],
    vendorId: json["vendor_id"].toString(),
    transporterId: json["transporter_id"],
    stationId: json["station_id"],
    vendorData: VendorData.fromJson(json["pickup_data"]),
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
    displayTime: json['display_time'] == 0? null: DateTime.fromMillisecondsSinceEpoch(int.parse(json['display_time'].toString()) * 1000),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "vendor_id": vendorId,
    "transporter_id": transporterId,
    "station_id": stationId,
    "pickup_data": vendorData.toJson(),
    "station_data": stationData.toJson(),
    "assign_status": assignStatus,
    "status": status,
    "assign_datetime": assignDatetime,
    "order_no": orderNo,
    "payment_type": paymentType,
    "is_schedule_delivery": isScheduleDelivery,
    "delivery_date": deliveryDate,
    "delivery_time": deliveryTime,
    "time_left_to_accept": timeLeftToAccept,
    "display_time": displayTime,

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

  final String stationId;
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
   String? geoFencingAddress;
  final String status;
   String? createdDate;
   String? updatedDate;

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
    createdDate: json["created_date"],
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
    "created_date": createdDate,
    "updated_date": updatedDate,
  };
}

class VendorData {
  VendorData({

    required this.address,
    required this.latitude,
    required this.longitude,

  });


  final String address;
  final String latitude;
  final String longitude;


  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(

    address: json["address"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),

  );

  Map<String, dynamic> toJson() => {

    "address": address,
    "latitude": latitude,
    "longitude": longitude,

  };
}

