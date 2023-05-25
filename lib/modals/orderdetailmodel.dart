// To parse this JSON data, do
//
//     final orderDetailModal = orderDetailModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderDetailModal orderDetailModalFromJson(String str) =>
    OrderDetailModal.fromJson(json.decode(str));

String orderDetailModalToJson(OrderDetailModal data) =>
    json.encode(data.toJson());

class OrderDetailModal {
  OrderDetailModal({
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
    required this.currency,
    required this.receiveQty,
    required this.otpCode,
    required this.geoFencingAddress,
    required this.totalQty,
    required this.orderDetails,
    required this.transporterName,
    required this.transporterMobile,
    required this.vehicleNumber,
    required this.rating,
    required this.review,
  });

  String id;
  String userId;
  String orderId;
  String stationId;
  String shippingCharge;
  String tax;
  String amount;
  String totalAmount;
  String orderStatus;
  String isOwner;
  String orderDate;
  String isScheduleDelivery;
  DateTime deliveryDate;
  String deliveryTime;
  String paymentType;
  String status;
  String isOrder;
  String rating;
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
  String currency;
  String receiveQty;
  String otpCode;
  String totalQty;
  String review;
  String transporterMobile;
  String transporterName;
  String vehicleNumber;
  dynamic geoFencingAddress;
  List<OrderDetail> orderDetails;

  factory OrderDetailModal.fromJson(Map<String, dynamic> json) =>
      OrderDetailModal(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        stationId: json["station_id"] ?? '',
        shippingCharge: json["shipping_charge"],
        tax: json["tax"],
        amount: json["amount"],
        totalAmount: json["total_amount"],
        totalQty: json["total_qty"],
        orderStatus: json["order_status"],
        isOwner: json["is_owner"],
        orderDate: json["order_date"],
        isScheduleDelivery: json["is_schedule_delivery"],
        deliveryDate: DateTime.parse(json["delivery_date"]),
        deliveryTime: json["delivery_time"],
        paymentType: json["payment_type"],
        status: json["status"] ?? '',
        isOrder: json["is_order"],
        ownerId: json["owner_id"] ?? '',
        stationName: json["station_name"] ?? '',
        contactPerson: json["contact_person"] ?? '',
        contactNumber: json["contact_number"] ?? '',
        alternateNumber: json["alternate_number"] ?? '',
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        pincode: json["pincode"] ?? '',
        landmark: json["landmark"] ?? '',
        address: json["address"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
        currency: json["currency"],
        transporterName: json["transporter_name"],
        vehicleNumber:
            json["vehicle_number"] == null ? '' : json['vehicle_number'],
        rating: json["rating"] == null ? '' : json["rating"],
        review: json["review"] == null ? '' : json["review"],
        transporterMobile: json["transporter_mobile"],
        receiveQty: json['receive_qty'] == null ? '' : json["receive_qty"],
        otpCode: json['otp_code'] == null ? '' : json["otp_code"],
        geoFencingAddress: json["geo_fencing_address"],
        orderDetails: List<OrderDetail>.from(
            json["order_details"].map((x) => OrderDetail.fromJson(x))),
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
        "order_date": orderDate,
        "is_schedule_delivery": isScheduleDelivery,
        "delivery_date":
            "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "payment_type": paymentType,
        "status": status,
        "is_order": isOrder,
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
        "currency": currency,
        "receive_qty": receiveQty,
        "total_qty": totalQty,
        "transporter_mobile": transporterMobile,
        "geo_fencing_address": geoFencingAddress,
        "rating": rating,
        "order_details":
            List<dynamic>.from(orderDetails.map((x) => x.toJson())),
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
    required this.imagePath,
    required this.qualityOfProduct,
  });

  String id;
  String cartOrderId;
  String cartUserId;
  String categoryId;
  String name;
  String type;
  String image;
  String measurement;
  String qty;
  String price;
  String currency;
  String totalPrice;
  String status;

  String imagePath;
  String qualityOfProduct;

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
        imagePath: json["image_path"],
        qualityOfProduct: json["quality_of_product"] == null
            ? ''
            : json["quality_of_product"],
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
        "image_path": imagePath,
        "quality_of_product": qualityOfProduct
      };
}
