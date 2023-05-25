

/*import 'package:meta/meta.dart';
import 'dart:convert';

TransportOrderDetailsModel transportOrderDetailsModelFromJson(String str) => TransportOrderDetailsModel.fromJson(json.decode(str));

String transportOrderDetailsModelToJson(TransportOrderDetailsModel data) => json.encode(data.toJson());

class TransportOrderDetailsModel {
  TransportOrderDetailsModel({
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
    required this.orderDetails,
  });

  final String id;
  final String orderId;
  final String vendorId;
  final String transporterId;
  final String stationId;
   VendorData? vendorData;
   StationData? stationData;
  final String assignStatus;
  final String status;
  final DateTime assignDatetime;
  final List<OrderDetail> orderDetails;

  factory TransportOrderDetailsModel.fromJson(Map<String, dynamic> json) => TransportOrderDetailsModel(
    id: json["id"],
    orderId: json["order_id"],
    vendorId: json["vendor_id"],
    transporterId: json["transporter_id"],
    stationId: json["station_id"],
    vendorData: (json["pickup_data"] == null)? null :  VendorData.fromJson(json["pickup_data"]),
    stationData: (json["station_data"] == null)? null :    StationData.fromJson(json["station_data"]),
    assignStatus: json["assign_status"],
    status: json["status"],
    assignDatetime: DateTime.parse(json["assign_datetime"]),
    orderDetails: List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "vendor_id": vendorId,
    "transporter_id": transporterId,
    "station_id": stationId,
    "pickup_data": vendorData?.toJson(),
    "station_data": stationData?.toJson(),
    "assign_status": assignStatus,
    "status": status,
    "assign_datetime": assignDatetime.toIso8601String(),
    "order_details": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
  };
}

class OrderDetail {
  OrderDetail({
    required this.id,
    required this.cartOrderId,
    required this.cartUserId,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.image,
    required this.measurement,
    required this.qty,
    required this.price,
    required this.currency,
    required this.totalPrice,
    required this.status,
    required this.cartCreated,
    required this.cartUpdated,
    required this.imagePath,
  });

  final String id;
  final String cartOrderId;
  final String cartUserId;
  final String categoryId;
  final String name;
  final String type;
  final String image;
  final String measurement;
  final String qty;
  final String price;
  final String currency;
  final String totalPrice;
  final String status;
  final DateTime cartCreated;
  final dynamic cartUpdated;
  final String imagePath;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    cartOrderId: json["cart_order_id"],
    cartUserId: json["cart_user_id"],
    categoryId: json["category_id"],
    name: json["name"],
    type: json["type"],
    image: json["image"],
    measurement: json["measurement"],
    qty: json["qty"],
    price: json["price"],
    currency: json["currency"],
    totalPrice: json["total_price"],
    status: json["status"],
    cartCreated: DateTime.parse(json["cart_created"]),
    cartUpdated: json["cart_updated"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_order_id": cartOrderId,
    "cart_user_id": cartUserId,
    "category_id": categoryId,
    "name": name,
    "type": type,
    "image": image,
    "measurement": measurement,
    "qty": qty,
    "price": price,
    "currency": currency,
    "total_price": totalPrice,
    "status": status,
    "cart_created": cartCreated.toIso8601String(),
    "cart_updated": cartUpdated,
    "image_path": imagePath,
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
  final String? geoFencingAddress;
  final String status;
  final String? createdDate;
  final String? updatedDate;

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
    required this.vendorId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });

  final String vendorId;
  final String name;
  final String email;
  final String mobile;
  final String address;
  final String latitude;
  final String longitude;
  final String status;
  final DateTime createdDate;
  final DateTime updatedDate;

  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
    vendorId: json["vendor_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
  );

  Map<String, dynamic> toJson() => {
    "vendor_id": vendorId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
  };
}*/


// To parse this JSON data, do
//
//     final transportOrderDetailsModel = transportOrderDetailsModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final transportOrderDetailsModel = transportOrderDetailsModelFromJson(jsonString);


// To parse this JSON data, do
//
//     final transportOrderDetailsModel = transportOrderDetailsModelFromJson(jsonString);

import 'dart:convert';

TransportOrderDetailsModel transportOrderDetailsModelFromJson(String str) =>
    TransportOrderDetailsModel.fromJson(json.decode(str));

String transportOrderDetailsModelToJson(TransportOrderDetailsModel data) =>
    json.encode(data.toJson());

class TransportOrderDetailsModel {
  TransportOrderDetailsModel({
    this.id,
    this.orderId,
    this.vendorId,
    this.transporterId,
    this.stationId,
    this.vendorData,
    this.stationData,
    this.assignStatus,
    this.status,
    this.assignDatetime,
    this.orderData,
  });

  String? id;
  String? orderId;
  String? vendorId;
  String? transporterId;
  String? stationId;
  VendorData? vendorData;
  StationData? stationData;
  String? assignStatus;
  String? status;
  String? assignDatetime;
  OrderData? orderData;

  factory TransportOrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      TransportOrderDetailsModel(
        id: json["id"],
        orderId: json["order_id"],
        vendorId: json["vendor_id"],
        transporterId: json["transporter_id"],
        stationId: json["station_id"],
        vendorData: (json["pickup_data"] == null)? null :VendorData.fromJson(json["pickup_data"]),
        stationData: (json["station_data"] == null)? null :StationData.fromJson(json["station_data"]),
        assignStatus: json["assign_status"],
        status: json["status"],
        assignDatetime: json["assign_datetime"],
        orderData: (json["order_data"] == null)? null :OrderData.fromJson(json["order_data"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "vendor_id": vendorId,
    "transporter_id": transporterId,
    "station_id": stationId,
    "pickup_data": vendorData?.toJson(),
    "station_data": stationData?.toJson(),
    "assign_status": assignStatus,
    "status": status,
    "assign_datetime": assignDatetime,
    "order_data": orderData?.toJson(),
  };
}

class OrderData {
  OrderData({
    this.id,
    this.userId,
    this.orderId,
    this.stationId,
    this.shippingCharge,
    this.tax,
    this.amount,
    this.totalAmount,
    this.currency,
    this.orderStatus,
    this.isOwner,
    this.orderDate,
    this.isScheduleDelivery,
    this.deliveryDate,
    this.deliveryTime,
    this.paymentType,
    this.status,
    this.isOrder,
    this.createdDate,
    this.updatedDate,
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
    this.orderDetails,
    this.displayStatus,
    this.todayDelivery,
    this.isAddFuel,
  });

  String? id;
  String? userId;
  String? orderId;
  String? stationId;
  String? shippingCharge;
  String? tax;
  String? amount;
  String? totalAmount;
  String? currency;
  String? orderStatus;
  String? isOwner;
  String? orderDate;
  String? isScheduleDelivery;
  String? deliveryDate;
  String? deliveryTime;
  String? paymentType;
  String? status;
  String? isOrder;
  String? createdDate;
  String? updatedDate;
  String? ownerId;
  String? stationName;
  String? contactPerson;
  String? contactNumber;
  String? alternateNumber;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? landmark;
  String? address;
  String? latitude;
  String? longitude;
  String? geoFencingAddress;
  String? displayStatus;
  List<OrderDetail>? orderDetails;
  int? todayDelivery;
  int? isAddFuel;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["id"].toString(),
    userId: json["user_id"].toString(),
    orderId: json["order_id"].toString(),
    stationId: json["station_id"].toString(),
    shippingCharge: json["shipping_charge"].toString(),
    tax: json["tax"].toString(),
    amount: json["amount"].toString(),
    totalAmount: json["total_amount"].toString(),
    currency: json["currency"].toString(),
    orderStatus: json["order_status"].toString(),
    isOwner: json["is_owner"].toString(),
    orderDate: json["order_date"],
    isScheduleDelivery: json["is_schedule_delivery"].toString(),
    deliveryDate: json["delivery_date"].toString(),
    deliveryTime: json["delivery_time"].toString(),
    paymentType: json["payment_type"].toString(),
    status: json["status"].toString(),
    isOrder: json["is_order"].toString(),
    createdDate: json["created_date"].toString(),
    updatedDate: json["updated_date"].toString(),
    stationName: json["station_name"].toString(),
    contactPerson: json["contact_person"].toString(),
    contactNumber: json["contact_number"].toString(),
    alternateNumber: json["alternate_number"].toString(),
    country: json["country"].toString(),
    state: json["state"].toString(),
    city: json["city"].toString(),
    pincode: json["pincode"].toString(),
    landmark: json["landmark"].toString(),
    address: json["address"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
    geoFencingAddress: json["geo_fencing_address"].toString(),
    displayStatus: json["display_status"].toString(),
    orderDetails: List<OrderDetail>.from(
        json["order_details"].map((x) => OrderDetail.fromJson(x))),
    todayDelivery: json["today_delivery"],
    isAddFuel: json["is_add_fuel"],
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
    "currency": currency,
    "order_status": orderStatus,
    "is_owner": isOwner,
    "order_date":orderDate,
    "is_schedule_delivery": isScheduleDelivery,
    "delivery_date": deliveryDate,   "delivery_time": deliveryTime,
    "payment_type": paymentType,
    "status": status,
    "is_order": isOrder,
    "created_date": createdDate,
    "updated_date": updatedDate,
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
    "display_status": displayStatus,
    "order_details":
    List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
    "today_delivery": todayDelivery,
    "is_add_fuel": isAddFuel,
  };
}

class OrderDetail {
  OrderDetail({
    this.id,
    this.cartOrderId,
    this.cartUserId,
    this.categoryId,
    this.name,
    this.type,
    this.image,
    this.measurement,
    this.qty,
    this.price,
    this.currency,
    this.totalPrice,
    this.status,
    this.cartCreated,
    this.cartUpdated,
    this.assignOrderId,
    this.assignOrderDetailId,
    this.transporterId,
    this.receiveQty,
    this.qualityOfProduct,
    this.receiveStatus,
    this.receiveDatetime,
    this.imagePath,
    this.addFuel,
  });

  String? id;
  String? cartOrderId;
  String? cartUserId;
  String? categoryId;
  String? name;
  String? type;
  String? image;
  String? measurement;
  String? qty;
  String? price;
  String? currency;
  String? totalPrice;
  String? status;
  String? cartCreated;
  String? cartUpdated;
  String? assignOrderId;
  String? assignOrderDetailId;
  String? transporterId;
  String? receiveQty;
  String? qualityOfProduct;
  String? receiveStatus;
  String? receiveDatetime;
  String? imagePath;
  int? addFuel;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    cartOrderId: json["cart_order_id"],
    cartUserId: json["cart_user_id"],
    categoryId: json["category_id"],
    name: json["name"],
    type: json["type"],
    image: json["image"],
    measurement: json["measurement"],
    qty: json["qty"],
    price: json["price"],
    currency: json["currency"],
    totalPrice: json["total_price"],
    status: json["status"],
    cartCreated: json["cart_created"],
    cartUpdated: json["cart_updated"],
    assignOrderId: json["assign_order_id"],
    assignOrderDetailId: json["assign_order_detail_id"],
    transporterId: json["transporter_id"],
    receiveQty: json["receive_qty"],
    qualityOfProduct: json["quality_of_product"],
    receiveStatus: json["receive_status"],
    receiveDatetime: json["receive_datetime"],
    imagePath: json["image_path"],
    addFuel: json["add_fuel"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_order_id": cartOrderId,
    "cart_user_id": cartUserId,
    "category_id": categoryId,
    "name": name,
    "type": type,
    "image": image,
    "measurement": measurement,
    "qty": qty,
    "price": price,
    "currency": currency,
    "total_price": totalPrice,
    "status": status,
    "cart_created": cartCreated,
    "cart_updated": cartUpdated,
    "assign_order_id": assignOrderId,
    "assign_order_detail_id": assignOrderDetailId,
    "transporter_id": transporterId,
    "receive_qty": receiveQty,
    "quality_of_product": qualityOfProduct,
    "receive_status": receiveStatus,
    "receive_datetime": receiveDatetime,
    "image_path": imagePath,
    "add_fuel": addFuel,
  };
}

class StationData {
  StationData({
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
    this.createdDate,
    this.updatedDate,
  });

  String? stationId;
  String? ownerId;
  String? stationName;
  String? contactPerson;
  String? contactNumber;
  String? alternateNumber;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? landmark;
  String? address;
  String? latitude;
  String? longitude;
  dynamic geoFencingAddress;
  String? status;
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
    this.address,
    this.latitude,
    this.longitude,
    this.contactNo,
  });
  String? address;
  String? latitude;
  String? longitude;
  String? contactNo;
  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
    address: json["address"].toString(),
    contactNo: json["contact_no"].toString(),
    latitude: json["latitude"].toString(),
    longitude: json["longitude"].toString(),
  );
  Map<String, dynamic> toJson() => {
    "address": address,
    "contact_no": contactNo,
    "latitude": latitude,
    "longitude": longitude,
  };
}




