import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/attender_management.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';

import '../station_manager_management_screen.dart';

class AddattenderController extends GetxController {
  static AddattenderController get to => Get.find();
  late TextEditingController attenderloginId;
  late TextEditingController attenderNameC;
  late TextEditingController attenderEmailC;
  late TextEditingController phoneNumberC;
  late TextEditingController attenderPasswordC;
  late TextEditingController attenderConfirmPasswordC;
  late TextEditingController attenderAddressC;
  late TextEditingController latitudeC;
  late TextEditingController longitudeC;
  late TextEditingController stationIdC;

  var isAddStationMangerLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    attenderloginId = TextEditingController();
    attenderNameC = TextEditingController();
    attenderEmailC = TextEditingController();
    phoneNumberC = TextEditingController();
    attenderPasswordC = TextEditingController();
    attenderConfirmPasswordC = TextEditingController();
    attenderAddressC = TextEditingController();
    latitudeC = TextEditingController();
    longitudeC = TextEditingController();
    stationIdC = TextEditingController();
  }

  validateAddAttenderFun(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      password,
      cPassword,
      address,
      latitude,
      longitude,
      stationId,
      user_type) async {
    isAddStationMangerLoading(true);
    Map<String, dynamic> stationMangerData = await WebServices()
        .addAttenderApiCall(userToken, loginId, name, email, mobile, password,
            cPassword, address, latitude, longitude, stationId, user_type);
    if (stationMangerData["status"] == "success") {
      Fluttertoast.showToast(
          msg: stationMangerData["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      // Get.back();
      Get.to(const AttenderMangement(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
      attenderloginId.clear();
      attenderNameC.clear();
      attenderEmailC.clear();
      attenderPasswordC.clear();
      attenderConfirmPasswordC.clear();
      attenderAddressC.clear();
      latitudeC.clear();
      longitudeC.clear();
      stationIdC.clear();
      isAddStationMangerLoading(false);
    } else {
      isAddStationMangerLoading(false);
    }
  }
}
