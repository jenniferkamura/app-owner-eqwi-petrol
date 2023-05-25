// To parse this JSON data, do
//
//     final compartmentDropDownModel = compartmentDropDownModelFromJson(jsonString);

import 'dart:convert';

CompartmentDropDownModel compartmentDropDownModelFromJson(String str) =>
    CompartmentDropDownModel.fromJson(json.decode(str));

String compartmentDropDownModelToJson(CompartmentDropDownModel data) =>
    json.encode(data.toJson());

class CompartmentDropDownModel {
  CompartmentDropDownModel({
    required this.compartmentDetail,
  });

  List<CompartmentDetail> compartmentDetail;

  factory CompartmentDropDownModel.fromJson(Map<String, dynamic> json) =>
      CompartmentDropDownModel(
        compartmentDetail: List<CompartmentDetail>.from(
            json["compartment_detail"]
                .map((x) => CompartmentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "compartment_detail":
            List<dynamic>.from(compartmentDetail.map((x) => x.toJson())),
      };
}

class CompartmentDetail {
  CompartmentDetail({
    required this.compartmentNo,
    required this.compartmentCapacity,
  });

  String compartmentNo;
  String compartmentCapacity;

  factory CompartmentDetail.fromJson(Map<String, dynamic> json) =>
      CompartmentDetail(
        compartmentNo: json["compartment_no"],
        compartmentCapacity: json["compartment_capacity"],
      );

  Map<String, dynamic> toJson() => {
        "compartment_no": compartmentNo,
        "compartment_capacity": compartmentCapacity,
      };
}

CompartmentDropDownModel listDataTanks =
    CompartmentDropDownModel(compartmentDetail: [
  CompartmentDetail(
    compartmentNo: "1",
    compartmentCapacity: '1000 ltr',
  ),
  CompartmentDetail(compartmentNo: "2", compartmentCapacity: '2000 ltr'),
  CompartmentDetail(compartmentNo: "3", compartmentCapacity: '3000 ltr'),
  CompartmentDetail(compartmentNo: "4", compartmentCapacity: '4000 ltr'),
  CompartmentDetail(compartmentNo: "5", compartmentCapacity: '5000 ltr'),
  CompartmentDetail(compartmentNo: "6", compartmentCapacity: '6000 ltr'),
]);
