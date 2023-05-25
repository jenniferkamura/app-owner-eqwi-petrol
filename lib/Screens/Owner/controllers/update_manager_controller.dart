import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';
import 'package:owner_eqwi_petrol/modals/staationmangerdetailmodal.dart';

import '../station_manager_management_screen.dart';

class UpdateStationMangerController extends GetxController {
  static UpdateStationMangerController get to => Get.find();
  late TextEditingController stationMangerloginId;
  late TextEditingController stationMangerNameC;
  late TextEditingController stationMangerEmailC;
  late TextEditingController phoneNumberC;
  // late TextEditingController stationMangerPasswordC;
  // late TextEditingController stationMangerConfirmPasswordC;
  late TextEditingController stationMangerAddressC;
  late TextEditingController latitudeC;
  late TextEditingController longitudeC;
  late TextEditingController stationIdC;
  late TextEditingController managerIdC;
  var isUpdateStationMangerLoading = false.obs;

  Rx<Mangerdetails> managerData = Mangerdetails().obs;
  var isManagerDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    stationMangerloginId = TextEditingController();
    stationMangerNameC = TextEditingController();
    stationMangerEmailC = TextEditingController();
    phoneNumberC = TextEditingController();
    // stationMangerPasswordC = TextEditingController();
    // stationMangerConfirmPasswordC = TextEditingController();
    stationMangerAddressC = TextEditingController();
    latitudeC = TextEditingController();
    longitudeC = TextEditingController();
    stationIdC = TextEditingController();
    managerIdC = TextEditingController();
  }

  validateUpdateStationMangerFun(
      String userToken,
      loginId,
      name,
      email,
      mobile,
      // password,
      // cPassword,
      address,
      latitude,
      longitude,
      stationId,
      managerId,
      userType) async {
    isUpdateStationMangerLoading(true);
    Map<String, dynamic> stationMangerData =
        await WebServices().updateStationManagertApiCall(
            userToken,
            loginId,
            name,
            email,
            mobile,
            // password,
            // cPassword,
            address,
            latitude,
            longitude,
            stationId,
            managerId,
            userType);
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
      // stationMangerPasswordC.clear();
      // stationMangerConfirmPasswordC.clear();
      stationMangerAddressC.clear();
      latitudeC.clear();
      longitudeC.clear();
      stationIdC.clear();
      isUpdateStationMangerLoading(false);
    } else {
      isUpdateStationMangerLoading(false);
    }
  }

  managerDetailsFun(String managerId, user_token, {bool isLoad = true}) async {
    if (isLoad) {
      isManagerDetails(true);
    }
    managerData.value =
        await WebServices().managerDetailsApi(managerId, user_token);
    print(managerId);
    print(managerData);
    print('managerFinalData $managerFinalData');
    isManagerDetails(false);
  }

  Mangerdetails get managerFinalData => managerData.value;
}
