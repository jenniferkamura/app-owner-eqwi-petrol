import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/petrol_stations_list.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';

import '../../../modals/stationmodel.dart';

class UpdateStationController extends GetxController {
  static UpdateStationController get to => Get.find();
  late TextEditingController petrolStationNameC;
  late TextEditingController personNameC;
  late TextEditingController phoneNumberC;
  late TextEditingController alternateNumberC;
  late TextEditingController countryC;
  late TextEditingController stateC;
  late TextEditingController cityC;
  // late TextEditingController pinCodeC;
  late TextEditingController addressC;
  late TextEditingController latitudeC;
  late TextEditingController longitudeC;
  late TextEditingController landmarkC;
  late TextEditingController stationIdC;
  var isAddStationLoading = false.obs;

  Rx<Stationdetailsmodel> stationData = Stationdetailsmodel().obs;
  var isStationDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    petrolStationNameC = TextEditingController();
    personNameC = TextEditingController();
    phoneNumberC = TextEditingController();
    alternateNumberC = TextEditingController();
    countryC = TextEditingController();
    stateC = TextEditingController();
    cityC = TextEditingController();
    // pinCodeC = TextEditingController();
    addressC = TextEditingController();
    latitudeC = TextEditingController();
    longitudeC = TextEditingController();
    landmarkC = TextEditingController();
    stationIdC = TextEditingController();
  }

  validateAddStationFun(
      String userToken,
      stationName,
      contactPerson,
      contactNumber,
      alterNateNumber,
      country,
      state,
      city,
      // pinCode,
      address,
      latitude,
      longitude,
      landmark,
      stationId) async {
    isAddStationLoading(true);
    Map<String, dynamic> forgot = await WebServices().updateStationApiCall(
        userToken,
        stationName,
        contactPerson,
        contactNumber,
        alterNateNumber,
        country,
        state,
        city,
        // pinCode,
        address,
        latitude,
        longitude,
        landmark,
        stationId);
    if (forgot["status"] == "success") {
      Fluttertoast.showToast(
          msg: forgot["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      Get.back();
      Get.to(PetrolStationsScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
      petrolStationNameC.clear();
      personNameC.clear();
      phoneNumberC.clear();
      alternateNumberC.clear();
      countryC.clear();
      stateC.clear();
      cityC.clear();
      // pinCodeC.clear();
      addressC.clear();
      latitudeC.clear();
      longitudeC.clear();
      landmarkC.clear();
      isAddStationLoading(false);
    } else {
      isAddStationLoading(false);
    }
  }

  stationDetailsFun(String stationId, user_token, {bool isLoad = true}) async {
    if (isLoad) {
      isStationDetails(true);
    }
    stationData.value =
        await WebServices().stationDetailsApi(stationId, user_token);

    isStationDetails(false);
  }

  Stationdetailsmodel get stationFinalData => stationData.value;
}
