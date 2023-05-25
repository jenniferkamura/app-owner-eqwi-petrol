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
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'dart:convert' as convert;
import '../../Common/constants.dart';
import '../../modals/petrolStationmodel.dart';
import 'controllers/add_manger_controller.dart';
import 'package:http/http.dart' as http;

class AddStationManagerScreen extends StatefulWidget {
  AddStationManagerScreen({Key? key}) : super(key: key);

  @override
  State<AddStationManagerScreen> createState() =>
      _AddStationManagerScreenState();
}

class _AddStationManagerScreenState extends State<AddStationManagerScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  List<StationList> stations = [];
  AddStationMangerController addStationController =
      Get.put(AddStationMangerController());

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
    if (addStationController.stationMangerNameC.text.isEmpty ||
        addStationController.stationMangerNameC.text.length < 3) {
      setState(() {
        managerNameError = true;
      });
    } else if (addStationController.stationMangerEmailC.text.isEmpty ||
        !emailValidation(addStationController.stationMangerEmailC.text)) {
      setState(() {
        isEmailError = true;
      });
    } else if (addStationController.phoneNumberC.text.isEmpty ||
        addStationController.phoneNumberC.text.length != 10) {
      setState(() {
        phoneNumberError = true;
      });
    } else if (addStationController.stationMangerPasswordC.text.isEmpty ||
        addStationController.stationMangerPasswordC.text.length < 4) {
      print(password);
      setState(() {
        passwordError = true;
      });
    } else if (addStationController
            .stationMangerConfirmPasswordC.text.isEmpty ||
        addStationController.stationMangerConfirmPasswordC.text.length < 4) {
      setState(() {
        cpasswordError = true;
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
    } else if (addStationController.stationMangerloginId.text.isEmpty ||
        addStationController.stationMangerloginId.text.length < 5) {
      setState(() {
        loginIdError = true;
      });
    } else if (addStationController.stationMangerAddressC.text.isEmpty ||
        addStationController.stationMangerAddressC.text.length < 5) {
      setState(() {
        addressError = true;
      });
    } else {
      print('goi');
      await addStationController.validateAddStationMangerFun(
        user_token.toString(),
        addStationController.stationMangerloginId.text,
        addStationController.stationMangerNameC.text,
        addStationController.stationMangerEmailC.text,
        addStationController.phoneNumberC.text,
        addStationController.stationMangerPasswordC.text,
        addStationController.stationMangerConfirmPasswordC.text,
        addStationController.stationMangerAddressC.text,
        '',
        '',
        selectedValue,
      );
    }
  }

  void initState() {
    super.initState();
    _passwordVisible = true;
    _cpasswordVisible = true;
    getstationsList();
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
      print("print is.....${result}");

      if (result['status'] == 'success') {
        result['data'].forEach((element) {
          setState(() {
            stations.add(StationList.fromJson(element));
            //   print(result);
          });
          print(stations);
        });
      }
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    //Get.back();
    return Future.value(false);
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context,
            title: 'Add Station Manager', onTaped: () {
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
                    controller: addStationController.stationMangerNameC,
                    hintText: 'Add Station Manger Name',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(25),
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
                    controller: addStationController.stationMangerEmailC,
                    hintText: 'Enter Email ',
                    readOnlytext: false,
                    typeOfRed: const <TextInputFormatter>[
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
                    controller: addStationController.phoneNumberC,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFieldTitle(title: 'Password '),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: addStationController.stationMangerPasswordC,
                  obscureText: _passwordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
                  ],
                  decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 / 1)),
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA0A0A0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFFA0A0A0),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      errorText: passwordError ? 'enter password' : null),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                      passwordError = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: 0,
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFieldTitle(title: 'Confirm Password '),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                    controller:
                        addStationController.stationMangerConfirmPasswordC,
                    obscureText: _cpasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp("[ ]")),
                    ],
                    decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10 / 1)),
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _cpasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFA0A0A0),
                          ),
                          onPressed: () {
                            setState(() {
                              _cpasswordVisible = !_cpasswordVisible;
                            });
                          },
                        ),
                        errorText:
                            cpasswordError ? 'enter confirm password' : null),
                    onChanged: (val) {
                      setState(() {
                        cpassword = val;
                        cpasswordError = false;
                      });
                    }),
              ],
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
                        buttonPadding:
                            const EdgeInsets.only(left: 15, right: 0),
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
                    controller: addStationController.stationMangerloginId,
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
                    controller: addStationController.stationMangerAddressC,
                    hintText: 'Address',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      //  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
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
                    addStationController.isAddStationMangerLoading.value
                        ? null
                        : saveFun(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: StadiumBorder()),
                child: addStationController.isAddStationMangerLoading.value
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ))
                    : Text(
                        'SAVE'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
