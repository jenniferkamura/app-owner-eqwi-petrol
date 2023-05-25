import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/change_address_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/petrol_stations_list.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/web_services_owner/owner_web_services.dart';

import '../../../modals/stationmodel.dart';
import '../../../Common/constants.dart';
import "dart:io";
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;

class UpdateStationController extends GetxController {
  String? cartCount;
  static UpdateStationController get to => Get.find();
  late TextEditingController petrolStationNameC;
  late TextEditingController personNameC;
  late TextEditingController phoneNumberC;
  late TextEditingController alternateNumberC;
  late TextEditingController countryC;
  late TextEditingController stateC;
  late TextEditingController cityC;
  late TextEditingController pinCodeC;
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
    pinCodeC = TextEditingController();
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
      pinCode,
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
      Get.to(
          ChangeAddressScreen(
              notificationsCountFun_value: () => notificationsCountFun()),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 400));
      petrolStationNameC.clear();
      personNameC.clear();
      phoneNumberC.clear();
      alternateNumberC.clear();
      countryC.clear();
      stateC.clear();
      cityC.clear();
      pinCodeC.clear();
      addressC.clear();
      latitudeC.clear();
      longitudeC.clear();
      landmarkC.clear();
      isAddStationLoading(false);
    } else {
      isAddStationLoading(false);
    }
  }

  void notificationsCountFun() async {
    print("datadtatatataatatta");
    Map<String, dynamic> bodyData = {
      'user_token': Constants.prefs?.getString('user_token').toString(),
    };
    print('gethomecarfffftData');
    http.Response response =
        await http.post(Uri.parse(Constants.baseurl + "home"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      if (result['status'] == 'success') {
        print(result['data']);

        cartCount = result['data']['cart_count'].toString();

        print('cartcountffffff :$cartCount');
      }
    }
  }

  stationDetailsFun(String stationId, user_token, {bool isLoad = true}) async {
    if (isLoad) {
      isStationDetails(true);
    }
    stationData.value =
        await WebServices().stationDetailsApi(stationId, user_token);
    print(stationId);
    print(stationData);

    isStationDetails(false);
  }

  Stationdetailsmodel get stationFinalData => stationData.value;
}
