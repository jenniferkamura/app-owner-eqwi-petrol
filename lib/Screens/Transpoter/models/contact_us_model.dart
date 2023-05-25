// To parse this JSON data, do
//
//     final contactUsModel = contactUsModelFromJson(jsonString);

import 'dart:convert';

ContactUsModel contactUsModelFromJson(String str) => ContactUsModel.fromJson(json.decode(str));

String contactUsModelToJson(ContactUsModel data) => json.encode(data.toJson());

class ContactUsModel {
  ContactUsModel({
    this.contactWebsiteUrl,
    this.contactAddress,
    this.contactLandlineNo,
    this.contactEmail,
    this.contactMobileNo,
  });

  String? contactWebsiteUrl;
  String? contactAddress;
  String? contactLandlineNo;
  String? contactEmail;
  String? contactMobileNo;

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
    contactWebsiteUrl: json["contact_website_url"],
    contactAddress: json["contact_address"],
    contactLandlineNo: json["contact_landline_no"],
    contactEmail: json["contact_email"],
    contactMobileNo: json["contact_mobile_no"],
  );

  Map<String, dynamic> toJson() => {
    "contact_website_url": contactWebsiteUrl,
    "contact_address": contactAddress,
    "contact_landline_no": contactLandlineNo,
    "contact_email": contactEmail,
    "contact_mobile_no": contactMobileNo,
  };
}
