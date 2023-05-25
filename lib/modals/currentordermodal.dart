// To parse this JSON data, do
//
//     final currentordersmodal = currentordersmodalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Currentordersmodal currentordersmodalFromJson(String str) =>
    Currentordersmodal.fromJson(json.decode(str));

String currentordersmodalToJson(Currentordersmodal data) =>
    json.encode(data.toJson());

class Currentordersmodal {
  Currentordersmodal({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.stationId,
    required this.shippingCharge,
    required this.tax,
    required this.amount,
    required this.totalAmount,
    required this.currency,
    required this.orderStatus,
    required this.isOwner,
    required this.orderDate,
    required this.isScheduleDelivery,
    // required this.deliveryDate,
    required this.deliveryTime,
    required this.paymentType,
    required this.timeLeftToAccept,
    required this.otpCode,
    required this.qualityOfProduct,
    required this.receiveQty,
    required this.receiveStatus,
    required this.receiveDatetime,
    required this.deliveredDatetime,
    required this.status,
    required this.isOrder,
    required this.RemainingAmount,
    required this.displayStatus,
    required this.totalQuantity,
    required this.measurment,
  });

  String id;
  String userId;
  String orderId;
  String stationId;
  String shippingCharge;
  String tax;
  String amount;
  String totalAmount;
  String currency;
  String orderStatus;
  String isOwner;
  String orderDate;
  String isScheduleDelivery;
  // String deliveryDate;
  String deliveryTime;
  String paymentType;
  String timeLeftToAccept;
  String otpCode;
  dynamic qualityOfProduct;
  dynamic receiveQty;
  String receiveStatus;
  dynamic receiveDatetime;
  dynamic deliveredDatetime;
  String status;
  String isOrder;
  // ignore: non_constant_identifier_names
  int RemainingAmount;
  String displayStatus;
  String totalQuantity;
  String measurment;
  factory Currentordersmodal.fromJson(Map<String, dynamic> json) =>
      Currentordersmodal(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        stationId: json["station_id"],
        shippingCharge: json["shipping_charge"],
        tax: json["tax"],
        amount: json["amount"],
        totalAmount: json["total_amount"],
        currency: json["currency"],
        orderStatus: json["order_status"],
        isOwner: json["is_owner"],
        RemainingAmount: json["remaining_amount"] ?? '',
        orderDate: json["order_date"] ?? '',
        isScheduleDelivery: json["is_schedule_delivery"] == null
            ? ''
            : json["is_schedule_delivery"],
        // deliveryDate:
        //     json["delivery_date"] == null ? '' : json["delivery_date"],
        deliveryTime:
            json["delivery_time"] == null ? '' : json["delivery_time"],
        paymentType: json["payment_type"] == null ? '' : json["payment_type"],
        timeLeftToAccept: json["time_left_to_accept"] == null
            ? ''
            : json["time_left_to_accept"],
        otpCode: json["otp_code"] == null ? '' : json["otp_code"],
        qualityOfProduct: json["quality_of_product"] == null
            ? ''
            : json["quality_of_product"],
        receiveQty: json["receive_qty"] == null ? '' : json["receive_qty"],
        receiveStatus:
            json["receive_status"] == null ? '' : json["receive_status"],
        receiveDatetime:
            json["receive_datetime"] == null ? '' : json["receive_datetime"],
        deliveredDatetime: json["delivered_datetime"] == null
            ? ''
            : json["delivered_datetime"],
        status: json["status"] == null ? '' : json["status"],
        isOrder: json["is_order"] == null ? '' : json["is_order"],
        displayStatus:
            json["display_status"] == null ? '' : json["display_status"],
        totalQuantity: json["total_qty"] == null ? "" : json["total_qty"],
        measurment: json["measurment"] == null ? "" : json["measurment"],
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
        "total_qty": totalQuantity,
        "order_date": orderDate,

        // "is_schedule_delivery": isScheduleDelivery,
        // "delivery_date":
        //     "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "payment_type": paymentType,
        "time_left_to_accept": timeLeftToAccept,
        "otp_code": otpCode,
        "quality_of_product": qualityOfProduct,
        "receive_qty": receiveQty,
        "receive_status": receiveStatus,
        "receive_datetime": receiveDatetime,
        "remaining_amount": RemainingAmount,
        "delivered_datetime": deliveredDatetime,
        "status": status,
        "is_order": isOrder,
        "display_status": displayStatus,
        "measurment": measurment,
      };
}
