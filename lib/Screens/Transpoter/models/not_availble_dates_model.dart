// To parse this JSON data, do
//
//     final notAvailbleDatesListModel = notAvailbleDatesListModelFromJson(jsonString);

import 'dart:convert';

NotAvailbleDatesListModel notAvailbleDatesListModelFromJson(String str) => NotAvailbleDatesListModel.fromJson(json.decode(str));

String notAvailbleDatesListModelToJson(NotAvailbleDatesListModel data) => json.encode(data.toJson());

class NotAvailbleDatesListModel {
  NotAvailbleDatesListModel({
    this.pagesCount,
    this.totalRecordsCount,
    this.result,
  });

  int? pagesCount;
  int? totalRecordsCount;
  List<Result>? result;

  factory NotAvailbleDatesListModel.fromJson(Map<String, dynamic> json) => NotAvailbleDatesListModel(
    pagesCount: json["pages_count"],
    totalRecordsCount: json["total_records_count"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages_count": pagesCount,
    "total_records_count": totalRecordsCount,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.setDate,
  });
  String? id;
  DateTime? setDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    setDate: DateTime.parse(json["set_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "set_date": "${setDate?.year.toString().padLeft(4, '0')}-${setDate?.month.toString().padLeft(2, '0')}-${setDate?.day.toString().padLeft(2, '0')}",
  };
}
