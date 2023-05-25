import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transporter_profile/screens/transporter_profile_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transpoter_home_screen.dart';

import '../models/selected_dropdown_val.dart';

class EditProfileController extends GetxController {
  static EditProfileController get to => Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleCapacityController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();

  @override
  void onInit() {   
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    vehicleNumberController = TextEditingController();
    vehicleCapacityController = TextEditingController();
    licenseNumberController = TextEditingController();
  }

  RxList<SelectedDropDValModel> _selectedTankDropdownValues =
      <SelectedDropDValModel>[].obs;
  addDataToSelectedDropdown(int index, String selVal) {
    print("CALLINF RGUSA ${_selectedTankDropdownValues.length}");
    if (_selectedTankDropdownValues.isNotEmpty) {
      print("HELLO");

      _selectedTankDropdownValues.forEach((SelectedDropDValModel item) {
        int currentObjIndex = _selectedTankDropdownValues.indexOf(item);

        print("Ex ind : ${item.selectedIndex} - VAL: ${item.selectedValue}");
        print("DEF ind : $index - VAL: $selVal");
        if (item.selectedIndex == index) {
          item.selectedValue = selVal;
          print("HELLO2");
          // _selectedTankDropdownValues.removeAt(currentObjIndex);
          // removeSelectedDropdown();
        }
        print(
            "NEWEx ind : ${item.selectedIndex} - NEWVAL: ${item.selectedValue}");
      });
    }
    _selectedTankDropdownValues.add(
        SelectedDropDValModel(selectedIndex: index + 1, selectedValue: selVal));
  }

  makeEmptyListSelDropDown() {
    _selectedTankDropdownValues.clear();
  }

  removeSelectedDropdown(SelectedDropDValModel obj) {
    _selectedTankDropdownValues.remove(obj);
  }

  List<SelectedDropDValModel> get getSelectedValGet =>
      _selectedTankDropdownValues.value;

  var isProfileLoad = false.obs;
  profileUpdateFun(
      String userToken,
      String name,
      String email,
      String mobileNo,
      String vehicleNo,
      String vehicleCapacity,
      String compartmentDetail,
      String vehiclefrontPhoto,
      String vehiclebackPhoto,
      String vehicleleftPhoto,
      String vehiclerightPhoto,
      String vehicleDocument,
      String numberOfCompartments,
      String documentNumber,
      String drivingLicense,
      String vehicleId) async {
    Map<String, dynamic> acceptAction = await TransportWebServices()
        .transporterUpdateProfileApi(
            userToken,
            name,
            email,
            mobileNo,
            vehicleNo,
            vehicleCapacity,
            compartmentDetail,
            vehiclefrontPhoto,
            vehiclebackPhoto,
            vehicleleftPhoto,
            vehiclerightPhoto,
            vehicleDocument,
            numberOfCompartments,
            documentNumber,
            drivingLicense,
            vehicleId);
    isProfileLoad(true);
    if (acceptAction["status"] == "success") {
      // print('***********');
      // print(acceptAction["data"]["order_id"]);
      /// print('***********');
      /* acceptOrderDetailsFun(userTokenC!,acceptAction["data"]["order_id"],isLoad: true);*/
      Fluttertoast.showToast(
          msg: acceptAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      Get.offAll(() => TransporterHomeScreen(),
          duration: const Duration(milliseconds: 400),
          transition: Transition.leftToRight);
      // Get.to(() => TransporterProfileScreen(),
      //     duration: Duration(milliseconds: 400),
      //     transition: Transition.rightToLeft);
      // update();
      /*  Get.back();
      Get.back();*/
      isProfileLoad(false);
    } else if (acceptAction["status"] == "error") {
      Fluttertoast.showToast(
          msg: acceptAction["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
      isProfileLoad(false);
    }
  }
}
