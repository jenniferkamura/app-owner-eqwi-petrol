import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';

import '../station_manager_management_screen.dart';

class AddStationMangerController extends GetxController {
  static AddStationMangerController get to => Get.find();
  late TextEditingController stationMangerloginId;
  late TextEditingController stationMangerNameC;
  late TextEditingController stationMangerEmailC;
  late TextEditingController phoneNumberC;
  late TextEditingController stationMangerPasswordC;
  late TextEditingController stationMangerConfirmPasswordC;
  late TextEditingController stationMangerAddressC;
  late TextEditingController latitudeC;
  late TextEditingController longitudeC;
  late TextEditingController stationIdC;

  var isAddStationMangerLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    stationMangerloginId = TextEditingController();
    stationMangerNameC = TextEditingController();
    stationMangerEmailC = TextEditingController();
    phoneNumberC = TextEditingController();
    stationMangerPasswordC = TextEditingController();
    stationMangerConfirmPasswordC = TextEditingController();
    stationMangerAddressC = TextEditingController();
    latitudeC = TextEditingController();
    longitudeC = TextEditingController();
    stationIdC = TextEditingController();
  }

  validateAddStationMangerFun(String userToken, loginId, name, email, mobile,
      password, cPassword, address, latitude, longitude, stationId) async {
    isAddStationMangerLoading(true);
    Map<String, dynamic> stationMangerData = await WebServices()
        .addStationManagertApiCall(userToken, loginId, name, email, mobile,
            password, cPassword, address, latitude, longitude, stationId);
    if (stationMangerData["status"] == "success") {
      Fluttertoast.showToast(
          msg: stationMangerData["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      Get.back();
      Get.to(StationManagerManagement(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
      stationMangerloginId.clear();
      stationMangerNameC.clear();
      stationMangerEmailC.clear();
      stationMangerPasswordC.clear();
      stationMangerConfirmPasswordC.clear();
      stationMangerAddressC.clear();
      latitudeC.clear();
      longitudeC.clear();
      stationIdC.clear();
      isAddStationMangerLoading(false);
    } else {
      isAddStationMangerLoading(false);
    }
  }
}
