// To parse this JSON data, do
//
//     final selectedDropDValModel = selectedDropDValModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SelectedDropDValModel selectedDropDValModelFromJson(String str) =>
    SelectedDropDValModel.fromJson(json.decode(str));

String selectedDropDValModelToJson(SelectedDropDValModel data) =>
    json.encode(data.toJson());

class SelectedDropDValModel {
  SelectedDropDValModel({
    required this.selectedIndex,
    required this.selectedValue,
  });

  int selectedIndex;
  String selectedValue;

  factory SelectedDropDValModel.fromJson(Map<String, dynamic> json) =>
      SelectedDropDValModel(
        selectedIndex: json["selected_index"],
        selectedValue: json["selected_value"],
      );

  Map<String, dynamic> toJson() => {
        "compartment_no": selectedIndex,
        "compartment_capacity": selectedValue,
      };
}
