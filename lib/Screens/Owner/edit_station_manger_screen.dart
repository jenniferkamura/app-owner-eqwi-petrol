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
import 'package:owner_eqwi_petrol/Screens/Owner/controllers/update_manager_controller.dart';
import 'dart:convert' as convert;
import '../../Common/constants.dart';
import '../../modals/petrolStationmodel.dart';
import 'controllers/add_manger_controller.dart';
import 'package:http/http.dart' as http;

class EditStationManagerScreen extends StatefulWidget {
  final String? managerId;
  EditStationManagerScreen({Key? key, this.managerId}) : super(key: key);

  @override
  State<EditStationManagerScreen> createState() =>
      _EditStationManagerScreenState();
}

class _EditStationManagerScreenState extends State<EditStationManagerScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  List<StationList> stations = [];

  AddStationMangerController addStationController =
      Get.put(AddStationMangerController());

  UpdateStationMangerController updateStationMangerController =
      Get.put(UpdateStationMangerController());

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
    if (updateStationMangerController.stationMangerNameC.text.isEmpty ||
        updateStationMangerController.stationMangerNameC.text.length < 3) {
      setState(() {
        managerNameError = true;
      });
    } else if (updateStationMangerController.stationMangerEmailC.text.isEmpty ||
        !emailValidation(
            updateStationMangerController.stationMangerEmailC.text)) {
      setState(() {
        isEmailError = true;
      });
    } else if (updateStationMangerController.phoneNumberC.text.isEmpty ||
        updateStationMangerController.phoneNumberC.text.length != 10) {
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
    } else if (updateStationMangerController
            .stationMangerloginId.text.isEmpty ||
        updateStationMangerController.stationMangerloginId.text.length < 5) {
      setState(() {
        loginIdError = true;
      });
    } else if (updateStationMangerController
            .stationMangerAddressC.text.isEmpty ||
        updateStationMangerController.stationMangerAddressC.text.length < 5) {
      setState(() {
        addressError = true;
      });
    } else {
      print('goi');
      await updateStationMangerController.validateUpdateStationMangerFun(
          user_token.toString(),
          updateStationMangerController.stationMangerloginId.text,
          updateStationMangerController.stationMangerNameC.text,
          updateStationMangerController.stationMangerEmailC.text,
          updateStationMangerController.phoneNumberC.text,
          // updateStationMangerController.stationMangerPasswordC.text,
          // updateStationMangerController.stationMangerConfirmPasswordC.text,
          updateStationMangerController.stationMangerAddressC.text,
          '',
          '',
          selectedValue,
          widget.managerId.toString(),
          'Manager');
    }
  }
  @override
  void initState() {
    _passwordVisible = true;
    _cpasswordVisible = true;
    getstationsList();
    getmangerDetails();
    super.initState();

  }

  Future<void> getmangerDetails() async {
    await updateStationMangerController
        .managerDetailsFun(widget.managerId.toString(), user_token,
            isLoad: false)
        .then((val) {
      updateStationMangerController.stationMangerNameC.text =
          updateStationMangerController.managerFinalData.data!.name.toString();
      updateStationMangerController.stationMangerEmailC.text =
          updateStationMangerController.managerFinalData.data!.email.toString();
      updateStationMangerController.phoneNumberC.text =
          updateStationMangerController.managerFinalData.data!.mobile
              .toString();
      updateStationMangerController.stationMangerloginId.text =
          updateStationMangerController.managerFinalData.data!.loginId
              .toString();
      updateStationMangerController.stationMangerAddressC.text =
          updateStationMangerController.managerFinalData.data!.address
              .toString();
      selectedValue = updateStationMangerController
          .managerFinalData.data!.stationId
          .toString();
      // print(updateStationMangerController.managerFinalData);
      // print(
      //     'name=${updateStationMangerController.managerFinalData.data!.name}');
    });

    updateStationMangerController.update();
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
                  controller: updateStationMangerController.stationMangerNameC,
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
                  controller: updateStationMangerController.stationMangerEmailC,
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
                  controller: updateStationMangerController.phoneNumberC,
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
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     CommonTextFieldTitle(title: 'Password '),
          //     SizedBox(
          //       height: 8,
          //     ),
          //     TextFormField(
          //       controller: addStationController.stationMangerPasswordC,
          //       obscureText: _passwordVisible,
          //       autovalidateMode: AutovalidateMode.onUserInteraction,
          //       inputFormatters: <TextInputFormatter>[
          //         FilteringTextInputFormatter.deny(RegExp("[ ]")),
          //       ],
          //       decoration: InputDecoration(
          //           hintText: 'Password',
          //           contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          //           border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10 / 1)),
          //           hintStyle: GoogleFonts.roboto(
          //             fontSize: 14,
          //             fontWeight: FontWeight.w400,
          //             color: Color(0xFFA0A0A0),
          //           ),
          //           suffixIcon: IconButton(
          //             icon: Icon(
          //               // Based on passwordVisible state choose the icon
          //               _passwordVisible
          //                   ? Icons.visibility
          //                   : Icons.visibility_off,
          //               color: Color(0xFFA0A0A0),
          //             ),
          //             onPressed: () {
          //               setState(() {
          //                 _passwordVisible = !_passwordVisible;
          //               });
          //             },
          //           ),
          //           errorText: passwordError ? 'enter password' : null),
          //       onChanged: (val) {
          //         setState(() {
          //           password = val;
          //           passwordError = false;
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   width: 0,
          //   height: 10,
          // ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     CommonTextFieldTitle(title: 'Confirm Password '),
          //     SizedBox(
          //       height: 8,
          //     ),
          //     TextFormField(
          //         controller:
          //             addStationController.stationMangerConfirmPasswordC,
          //         obscureText: _cpasswordVisible,
          //         autovalidateMode: AutovalidateMode.onUserInteraction,
          //         inputFormatters: <TextInputFormatter>[
          //           FilteringTextInputFormatter.deny(RegExp("[ ]")),
          //         ],
          //         decoration: InputDecoration(
          //             hintText: 'Password',
          //             contentPadding:
          //                 EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10 / 1)),
          //             hintStyle: GoogleFonts.roboto(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400,
          //               color: Color(0xFFA0A0A0),
          //             ),
          //             suffixIcon: IconButton(
          //               icon: Icon(
          //                 // Based on passwordVisible state choose the icon
          //                 _passwordVisible
          //                     ? Icons.visibility
          //                     : Icons.visibility_off,
          //                 color: Color(0xFFA0A0A0),
          //               ),
          //               onPressed: () {
          //                 setState(() {
          //                   _cpasswordVisible = !_cpasswordVisible;
          //                 });
          //               },
          //             ),
          //             errorText:
          //                 cpasswordError ? 'enter confirm password' : null),
          //         onChanged: (val) {
          //           setState(() {
          //             cpassword = val;
          //             cpasswordError = false;
          //           });
          //         }),
          //   ],
          // ),
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
                  controller:
                      updateStationMangerController.stationMangerloginId,
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
                  controller:
                      updateStationMangerController.stationMangerAddressC,
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
              onPressed: () => updateStationMangerController
                      .isUpdateStationMangerLoading.value
                  ? null
                  : saveFun(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: StadiumBorder()),
              child: updateStationMangerController
                      .isUpdateStationMangerLoading.value
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
