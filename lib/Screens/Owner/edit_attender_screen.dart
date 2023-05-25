// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/controllers/add_attender_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/controllers/update_attender_controller.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/controllers/update_manager_controller.dart';
import 'dart:convert' as convert;
import '../../Common/constants.dart';
import '../../modals/petrolStationmodel.dart';
import 'controllers/add_manger_controller.dart';
import 'package:http/http.dart' as http;

class UpdateAttender extends StatefulWidget {
  final String? managerId;
  const UpdateAttender({Key? key, this.managerId}) : super(key: key);

  @override
  State<UpdateAttender> createState() => _UpdateAttenderState();
}

class _UpdateAttenderState extends State<UpdateAttender> {
  String? user_token = Constants.prefs?.getString('user_token');
  List<StationList> stations = [];

  AddattenderController addattenderController =
      Get.put(AddattenderController());

  UpdateAttenderController updateAttenderController =
      Get.put(UpdateAttenderController());

  bool _passwordVisible = false;
  bool _cpasswordVisible = false;

  String managerName = "";
  bool managerNameError = false;
  String email = "";
  bool isEmailError = false;
  String phoneNumber = "";
  bool phoneNumberError = false;
  String password = "";
  bool passwordError = false;
  String cpassword = "";
  bool cpasswordError = false;
  String loginId = "";
  bool loginIdError = false;
  String address = "";
  bool addressError = false;
  String selectstn = "";
  bool selectStnError = false;

  emailValidation(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  saveFun() async {
    print('update');
    if (updateAttenderController.attenderNameC.text.isEmpty ||
        updateAttenderController.attenderNameC.text.length < 3) {
      setState(() {
        managerNameError = true;
      });
    } else if (updateAttenderController.attenderEmailC.text.isEmpty ||
        !emailValidation(updateAttenderController.attenderEmailC.text)) {
      setState(() {
        isEmailError = true;
      });
    } else if (updateAttenderController.phoneNumberC.text.isEmpty ||
        updateAttenderController.phoneNumberC.text.length != 10) {
      setState(() {
        phoneNumberError = true;
      });
    } else if (selectedValue == null || selectedValue == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select station",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // setState(() {
      //   selectStnError = true;
      // });
    } else if (updateAttenderController.attenderloginId.text.isEmpty ||
        updateAttenderController.attenderloginId.text.length < 5) {
      setState(() {
        loginIdError = true;
      });
    } else if (updateAttenderController.attenderAddressC.text.isEmpty ||
        updateAttenderController.attenderAddressC.text.length < 5) {
      setState(() {
        addressError = true;
      });
    } else {
      print('goi');
      await updateAttenderController.validateUpdateStationMangerFun(
          user_token.toString(),
          updateAttenderController.attenderloginId.text,
          updateAttenderController.attenderNameC.text,
          updateAttenderController.attenderEmailC.text,
          updateAttenderController.phoneNumberC.text,
          // updateAttenderController.attenderPasswordC.text,
          // updateAttenderController.attenderConfirmPasswordC.text,
          updateAttenderController.attenderAddressC.text,
          '',
          '',
          selectedValue,
          widget.managerId.toString(),
          'Attendant');
    }
  }
  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _cpasswordVisible = true;
    getstationsList();
    getmangerDetails();
  }

  Future<void> getmangerDetails() async {
    await updateAttenderController
        .managerDetailsFun(widget.managerId.toString(), user_token,
            isLoad: false)
        .then((val) {
      updateAttenderController.attenderNameC.text =
          updateAttenderController.managerFinalData.data!.name.toString();
      updateAttenderController.attenderEmailC.text =
          updateAttenderController.managerFinalData.data!.email.toString();
      updateAttenderController.phoneNumberC.text =
          updateAttenderController.managerFinalData.data!.mobile.toString();
      updateAttenderController.attenderloginId.text =
          updateAttenderController.managerFinalData.data!.loginId.toString();
      updateAttenderController.attenderAddressC.text =
          updateAttenderController.managerFinalData.data!.address.toString();
      selectedValue =
          updateAttenderController.managerFinalData.data!.stationId.toString();
      // print(updateStationMangerController.managerFinalData);
      // print(
      //     'name=${updateStationMangerController.managerFinalData.data!.name}');
    });

    updateAttenderController.update();
  }

  Future<void> getstationsList() async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };

    print(bodyData);
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "stations"), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //   print("print is.....${result}");

      if (result['status'] == 'success') {
        result['data'].forEach((element) {
          setState(() {
            stations.add(StationList.fromJson(element));
            //   print(result);
          });
          //   print(stations);
        });
      }
    }
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context,
          title: 'Update Station Manager', onTaped: () {
        Navigator.pop(context);
      }),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldTitle(title: 'Name '),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateAttenderController.attenderNameC,
                  hintText: 'Add Station Manger Name',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                    FilteringTextInputFormatter.deny(RegExp("[]")),
                  ],
                  onChangeVal: (val) {
                    setState(() {
                      managerName = val;
                      managerNameError = false;
                    });
                  },
                  isErrorText: managerNameError,
                  isErrorTextString: 'Please enter manager name',
                  keyboardPopType: TextInputType.text,
                  filledColor: Colors.transparent,
                  focusBorderColor: AppColor.blackColor,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1),
            ],
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldTitle(title: 'Email '),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateAttenderController.attenderEmailC,
                  hintText: 'Enter Email ',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    // FilteringTextInputFormatter.allow(RegExp(
                    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),
                  ],
                  onChangeVal: (val) {
                    setState(() {
                      email = val;
                      isEmailError = false;
                    });
                  },
                  isErrorText: isEmailError,
                  isErrorTextString: 'Please enter valid Email',
                  keyboardPopType: TextInputType.text,
                  filledColor: Colors.transparent,
                  focusBorderColor: AppColor.blackColor,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1),
            ],
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldTitle(title: 'Phone Number'),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateAttenderController.phoneNumberC,
                  hintText: 'Phone Number',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  onChangeVal: (val) {
                    setState(() {
                      phoneNumber = val;
                      phoneNumberError = false;
                    });
                  },
                  isErrorText: phoneNumberError,
                  isErrorTextString: 'Please enter phone number',
                  keyboardPopType: TextInputType.number,
                  filledColor: Colors.transparent,
                  focusBorderColor: AppColor.blackColor,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1),
            ],
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFieldTitle(title: 'Select Station '),
                SizedBox(
                  height: 6,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select station',
                              style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFFAAAAAA)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: stations
                          .map((item) => DropdownMenuItem<String>(
                                value: item.stationId,
                                child: Text(
                                  item.stationName,
                                  style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                        ),
                      ),
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 55,
                      buttonPadding: const EdgeInsets.only(left: 15, right: 0),
                      buttonDecoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD1D1DC)),
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.whiteColor,
                      ),
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 132,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldTitle(title: 'Login Id '),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateAttenderController.attenderloginId,
                  hintText: 'login Id ',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
                  ],
                  onChangeVal: (val) {
                    setState(() {
                      loginId = val;
                      loginIdError = false;
                    });
                  },
                  isErrorText: loginIdError,
                  isErrorTextString: 'Please enter login Id',
                  keyboardPopType: TextInputType.text,
                  filledColor: Colors.transparent,
                  focusBorderColor: AppColor.blackColor,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1),
            ],
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextFieldTitle(title: 'Address '),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateAttenderController.attenderAddressC,
                  hintText: 'Address',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                    FilteringTextInputFormatter.deny(RegExp("[]")),
                  ],
                  onChangeVal: (val) {
                    setState(() {
                      address = val;
                      addressError = false;
                    });
                  },
                  isErrorText: addressError,
                  isErrorTextString: 'Please enter address',
                  keyboardPopType: TextInputType.text,
                  filledColor: Colors.transparent,
                  focusBorderColor: AppColor.blackColor,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 7),
            ],
          ),
          SizedBox(
            width: 0,
            height: 40,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () =>
                  updateAttenderController.isUpdateStationMangerLoading.value
                      ? null
                      : saveFun(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: StadiumBorder()),
              child: updateAttenderController.isUpdateStationMangerLoading.value
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : Text(
                      'Update'.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.whiteColor),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
