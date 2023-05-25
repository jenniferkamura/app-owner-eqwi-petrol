// To parse this JSON data, do
//
//     final buttonStatusModel = buttonStatusModelFromJson(jsonString);

import 'dart:convert';

ButtonStatusModel buttonStatusModelFromJson(String str) => ButtonStatusModel.fromJson(json.decode(str));

String buttonStatusModelToJson(ButtonStatusModel data) => json.encode(data.toJson());

class ButtonStatusModel {
  ButtonStatusModel({
    this.paymentPending,
    this.signaturePending,
    this.invalidOtp,
    this.currency,
    this.pendingAmount,
  });

  int? paymentPending;
  int? signaturePending;
  int? invalidOtp;
  String? currency;
  int? pendingAmount;

  factory ButtonStatusModel.fromJson(Map<String, dynamic> json) => ButtonStatusModel(
    paymentPending: json["payment_pending"],
    signaturePending: json["signature_pending"],
    invalidOtp: json["invalid_otp"],
    currency: json["currency"],
    pendingAmount: json["pending_amount"],
  );

  Map<String, dynamic> toJson() => {
    "payment_pending": paymentPending,
    "signature_pending": signaturePending,
    "invalid_otp": invalidOtp,
    "currency": currency,
    "pending_amount": pendingAmount,
  };
}
