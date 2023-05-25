// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_app_bar.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/controllers/add_station_controler.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/petrol_stations_list.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/use_my_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../Common/constants.dart';

class AddStationScreen extends StatefulWidget {
  const AddStationScreen({Key? key}) : super(key: key);

  @override
  State<AddStationScreen> createState() => _AddStationScreenState();
}

class _AddStationScreenState extends State<AddStationScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  AddStationController addStationController = Get.put(AddStationController());
  bool isAlternate = false;
  bool isLandmark = false;

  String petrolStation = "";
  bool petrolStationError = false;
  String personName = "";
  bool personNameError = false;
  String phoneNumber = "";
  bool phoneNumberError = false;
  String alternateNumber = "";
  bool alternateError = false;
  String country = "";
  bool countryError = false;
  String state = "";
  bool stateError = false;
  String city = "";
  bool cityError = false;
  String pinCode = "";
  bool pinCodeError = false;
  String colony = "";
  bool colonyError = false;
  String landmark = "";
  bool landmarkError = false;
  String? latitude = "";
  String? longitude = "";

  saveFun() async {
    if (addStationController.petrolStationNameC.text.isEmpty ||
        addStationController.petrolStationNameC.text.length < 3) {
      setState(() {
        petrolStationError = true;
      });
    } else if (addStationController.personNameC.text.isEmpty ||
        addStationController.personNameC.text.length < 3) {
      setState(() {
        personNameError = true;
      });
    } else if (addStationController.phoneNumberC.text.isEmpty) {
      setState(() {
        phoneNumberError = true;
      });
    } else if (addStationController.countryC.text.isEmpty ||
        addStationController.countryC.text.length < 3) {
      setState(() {
        countryError = true;
      });
    } else if (addStationController.stateC.text.isEmpty ||
        addStationController.stateC.text.length < 3) {
      setState(() {
        stateError = true;
      });
    } else if (addStationController.cityC.text.isEmpty ||
        addStationController.cityC.text.length < 3) {
      setState(() {
        cityError = true;
      });
    }
    // else if (addStationController.pinCodeC.text.isEmpty ||
    //     addStationController.pinCodeC.text.length < 2) {
    //   setState(() {
    //     pinCodeError = true;
    //   });
    // }
    else if (addStationController.addressC.text.isEmpty ||
        addStationController.addressC.text.length < 3) {
      setState(() {
        colonyError = true;
      });
    } else {
      print('goi');
      await addStationController.validateAddStationFun(
        user_token.toString(),
        addStationController.petrolStationNameC.text,
        addStationController.personNameC.text,
        addStationController.phoneNumberC.text,
        addStationController.alternateNumberC.text,
        addStationController.countryC.text,
        addStationController.stateC.text,
        addStationController.cityC.text,
        // addStationController.pinCodeC.text,
        addStationController.addressC.text,
        addStationController.latitudeC.text,
        addStationController.longitudeC.text,
        addStationController.landmarkC.text,
      );
    }
  }

  Future<void> checkServiceAvilble() async {
    Map<String, dynamic> bodyData = {
      'latitude': addStationController.latitudeC.text,
      'longitude': addStationController.longitudeC.text,
    };
    print(bodyData);
    http.Response response = await http.post(
        Uri.parse("${Constants.baseurl}check_service_available"),
        body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array

      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        saveFun();
      } else {
        Fluttertoast.showToast(
            msg: "Service not availble at your location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to right, #6db000 #6db000)",
            //  backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedData;

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    // Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom.commonAppBarCustom(context, title: 'Add Station',
            onTaped: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TabbarScreen()));
        }),
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFieldTitle(title: 'Petrol Station Name'),
                SizedBox(
                  height: 6,
                ),
                CommonTextFieldAuthentication(
                    controller: addStationController.petrolStationNameC,
                    hintText: 'Station Name',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                      FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                    ],
                    onChangeVal: (val) {
                      setState(() {
                        petrolStation = val;
                        petrolStationError = false;
                      });
                    },
                    isErrorText: petrolStationError,
                    isErrorTextString:
                        'Please enter station name minimum 3 letters',
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
                CommonTextFieldTitle(title: 'Contact Person Name'),
                SizedBox(
                  height: 6,
                ),
                CommonTextFieldAuthentication(
                    controller: addStationController.personNameC,
                    hintText: 'Person Name',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                      FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                    ],
                    onChangeVal: (val) {
                      setState(() {
                        personName = val;
                        personNameError = false;
                      });
                    },
                    isErrorText: personNameError,
                    isErrorTextString:
                        'Please enter person name minimum 3 letters',
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
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      FilteringTextInputFormatter.deny(RegExp("[ ]")),
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChangeVal: (val) {
                      setState(() {
                        phoneNumber = val;
                        phoneNumberError = false;
                      });
                    },
                    isErrorText: phoneNumberError,
                    isErrorTextString: 'Please enter valid phone number',
                    keyboardPopType: TextInputType.number,
                    filledColor: Colors.transparent,
                    focusBorderColor: AppColor.blackColor,
                    textCapitalization: TextCapitalization.none,
                    maxLines: 1),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  isAlternate = !isAlternate;
                }),
                icon: Icon(
                  Icons.add_circle_sharp,
                  color: Color(0xFF2874F0),
                  size: 20,
                ),
                label: Text(
                  'Add Alternate Phone Number',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2874F0),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isAlternate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alternate Number',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  CommonTextFieldAuthentication(
                      controller: addStationController.alternateNumberC,
                      hintText: 'Alternate Number',
                      readOnlytext: false,
                      typeOfRed: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChangeVal: (val) {
                        setState(() {
                          alternateNumber = val;
                          alternateError = false;
                        });
                      },
                      isErrorText: alternateError,
                      isErrorTextString: 'Please enter alternate number',
                      keyboardPopType: TextInputType.text,
                      filledColor: Colors.transparent,
                      focusBorderColor: AppColor.blackColor,
                      textCapitalization: TextCapitalization.none,
                      maxLines: 1),
                  SizedBox(
                    height: 10,
                    width: 0,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(color: Colors.blue),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                var selectedaddress =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UseMyLocationScreen(),
                ));
                print('address coming');
                print(selectedaddress);
                if (selectedaddress['latitude'] != null) {
                  setState(() {
                    selectedData = selectedaddress;
                    addStationController.countryC.text =
                        selectedData['country'].toString();
                    addStationController.stateC.text =
                        selectedData['state'].toString();
                    // addStationController.pinCodeC.text =
                    //     selectedData['postalCode'].toString();
                    addStationController.cityC.text =
                        selectedData['locality'].toString();
                    addStationController.addressC.text =
                        selectedData['street'].toString();
                    addStationController.latitudeC.text =
                        selectedData['latitude'].toString();
                    addStationController.longitudeC.text =
                        selectedData['longitude'].toString();
                  });
                }
              },
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 22,
              ),
              label: Text(
                'Use my location',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 0,
              height: 10,
            ),
            /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF848484))),
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24 / 2),
                            color: Color(0xFF89A619),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Image.asset(
                              '${StringConstatnts
                                  .assets}room_black_24dp 1.png',
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Use my location',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF89A619),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),*/
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextFieldTitle(title: 'Country'),
                      SizedBox(
                        height: 6,
                      ),
                      CommonTextFieldAuthentication(
                          controller: addStationController.countryC,
                          hintText: 'Country',
                          readOnlytext: true,
                          typeOfRed: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                            FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                          ],
                          onChangeVal: (val) {
                            setState(() {
                              country = val;
                              countryError = false;
                            });
                          },
                          isErrorText: countryError,
                          isErrorTextString: 'Please enter country',
                          keyboardPopType: TextInputType.text,
                          filledColor: Colors.transparent,
                          focusBorderColor: AppColor.blackColor,
                          textCapitalization: TextCapitalization.none,
                          maxLines: 1),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextFieldTitle(title: 'County'),
                      SizedBox(
                        height: 6,
                      ),
                      CommonTextFieldAuthentication(
                          controller: addStationController.stateC,
                          hintText: 'County',
                          readOnlytext: false,
                          typeOfRed: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                            FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                          ],
                          onChangeVal: (val) {
                            setState(() {
                              state = val;
                              stateError = false;
                            });
                          },
                          isErrorText: stateError,
                          isErrorTextString: 'Please enter state',
                          keyboardPopType: TextInputType.text,
                          filledColor: Colors.transparent,
                          focusBorderColor: AppColor.blackColor,
                          textCapitalization: TextCapitalization.none,
                          maxLines: 1),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 0,
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextFieldTitle(title: 'City'),
                      SizedBox(
                        height: 6,
                      ),
                      CommonTextFieldAuthentication(
                          controller: addStationController.cityC,
                          hintText: 'City',
                          readOnlytext: false,
                          typeOfRed: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                            FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                          ],
                          onChangeVal: (val) {
                            setState(() {
                              city = val;
                              cityError = false;
                            });
                          },
                          isErrorText: cityError,
                          isErrorTextString: 'Please enter city',
                          keyboardPopType: TextInputType.text,
                          filledColor: Colors.transparent,
                          focusBorderColor: AppColor.blackColor,
                          textCapitalization: TextCapitalization.none,
                          maxLines: 1),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: 10,
                //   height: 0,
                // ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       CommonTextFieldTitle(title: 'Pin code'),
                //       SizedBox(
                //         height: 6,
                //       ),
                //       CommonTextFieldAuthentication(
                //           controller: addStationController.pinCodeC,
                //           hintText: 'Pin code',
                //           readOnlytext: false,
                //           typeOfRed: <TextInputFormatter>[
                //             FilteringTextInputFormatter.allow(
                //                 RegExp("[a-z A-Z 0-9]")),
                //           ],
                //           onChangeVal: (val) {
                //             setState(() {
                //               pinCode = val;
                //               pinCodeError = false;
                //             });
                //           },
                //           isErrorText: pinCodeError,
                //           isErrorTextString: 'Please enter pincode',
                //           keyboardPopType: TextInputType.phone,
                //           filledColor: Colors.transparent,
                //           focusBorderColor: AppColor.blackColor,
                //           textCapitalization: TextCapitalization.none,
                //           maxLines: 1),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(
              width: 0,
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextFieldTitle(title: 'Road name, Area, colony'),
                SizedBox(
                  height: 6,
                ),
                CommonTextFieldAuthentication(
                    controller: addStationController.addressC,
                    hintText: 'Road name, Area, colony',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-z A-Z 0-9 @ - / .]")),
                    ],
                    onChangeVal: (val) {
                      setState(() {
                        colony = val;
                        colonyError = false;
                      });
                    },
                    isErrorText: colonyError,
                    isErrorTextString: 'Please enter road,area,colony',
                    keyboardPopType: TextInputType.text,
                    filledColor: Colors.transparent,
                    focusBorderColor: AppColor.blackColor,
                    textCapitalization: TextCapitalization.none,
                    maxLines: 1),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  isLandmark = !isLandmark;
                }),
                icon: Icon(
                  Icons.add_circle_sharp,
                  color: Color(0xFF2874F0),
                  size: 20,
                ),
                label: Text(
                  'Add nearby famous land mark',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2874F0),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLandmark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Landmark',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  CommonTextFieldAuthentication(
                      controller: addStationController.landmarkC,
                      hintText: 'Landmark',
                      readOnlytext: false,
                      typeOfRed: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z A-Z 0-9 @ - / .]")),
                      ],
                      onChangeVal: (val) {
                        setState(() {
                          landmark = val;
                          landmarkError = false;
                        });
                      },
                      isErrorText: landmarkError,
                      isErrorTextString: 'Please enter alternate number',
                      keyboardPopType: TextInputType.text,
                      filledColor: Colors.transparent,
                      focusBorderColor: AppColor.blackColor,
                      textCapitalization: TextCapitalization.none,
                      maxLines: 1),
                  SizedBox(
                    height: 20,
                    width: 0,
                  ),
                ],
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () => addStationController.isAddStationLoading.value
                    ? null
                    : saveFun(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: StadiumBorder()),
                child: addStationController.isAddStationLoading.value
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
            SizedBox(
              height: 20,
              width: 0,
            ),
          ],
        ),
      ),
    );
  }
}
