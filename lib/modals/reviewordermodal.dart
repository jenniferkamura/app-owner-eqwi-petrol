// To parse this JSON data, do
//
//     final receiveneworderreviewmodal = receiveneworderreviewmodalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Receiveneworderreviewmodal receiveneworderreviewmodalFromJson(String str) =>
    Receiveneworderreviewmodal.fromJson(json.decode(str));

String receiveneworderreviewmodalToJson(Receiveneworderreviewmodal data) =>
    json.encode(data.toJson());

class Receiveneworderreviewmodal {
  Receiveneworderreviewmodal({
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
    required this.assignOrderId,
    required this.assignOrderDetailId,
    required this.transporterId,
    required this.otpCode,
    required this.receiveQty,
    required this.qualityOfProduct,
    required this.receiveStatus,
    required this.receiveDatetime,
    required this.deliveredDatetime,
    required this.orderId,
    required this.orderDate,
    required this.imagePath,
    required this.paymentType,
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
  String cartCreated;
  dynamic cartUpdated;
  String assignOrderId;
  String assignOrderDetailId;
  String transporterId;
  String otpCode;
  String receiveQty;
  String qualityOfProduct;
  String receiveStatus;
  String receiveDatetime;
  String deliveredDatetime;
  String orderId;
  String orderDate;
  String imagePath;
  String paymentType;
  factory Receiveneworderreviewmodal.fromJson(Map<String, dynamic> json) =>
      Receiveneworderreviewmodal(
        id: json["id"],
        cartOrderId: json["cart_order_id"],
        cartUserId: json["cart_user_id"],
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        image: json["image"],
        measurement: json["measurement"] == null ? 0 : json["measurement"],
        qty: json["qty"] == null ? '' : json["qty"],
        price: json["price"] == null ? '' : json["price"],
        currency: json["currency"] == null ? '' : json["currency"],
        totalPrice: json["total_price"] == null ? '' : json["total_price"],
        status: json["status"],
        cartCreated: json["cart_created"] == null ? '' : json["cart_created"],
        cartUpdated: json["cart_updated"] == null ? '' : json["cart_updated"],
        assignOrderId: json["assign_order_id"],
        assignOrderDetailId: json["assign_order_detail_id"],
        transporterId: json["transporter_id"],
        otpCode: json["otp_code"],
        receiveQty: json["receive_qty"] == null ? '' : json["receive_qty"],
        qualityOfProduct: json["quality_of_product"] == null
            ? ''
            : json["quality_of_product"],
        receiveStatus:
            json["receive_status"] == null ? '' : json["receive_status"],
        receiveDatetime:
            json["receive_datetime"] == null ? '' : json["receive_datetime"],
        deliveredDatetime: json["delivered_datetime"],
        orderId: json["order_id"],
        orderDate: json["order_date"],
        imagePath: json["image_path"],
        paymentType: json["payment_type"],
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
        "otp_code": otpCode,
        "receive_qty": receiveQty,
        "quality_of_product": qualityOfProduct,
        "receive_status": receiveStatus,
        "receive_datetime": receiveDatetime,
        "delivered_datetime": deliveredDatetime,
        "order_id": orderId,
        "order_date": orderDate,
        "image_path": imagePath,
        "payment_type": paymentType
      };
}
