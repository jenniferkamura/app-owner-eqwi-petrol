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
import 'package:owner_eqwi_petrol/Screens/Owner/update_station_location_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/use_my_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/constants.dart';
import 'controllers/update_station_controller.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class UpdateStationScreen extends StatefulWidget {
  final String? stationId;
  const UpdateStationScreen({Key? key, this.stationId}) : super(key: key);

  @override
  State<UpdateStationScreen> createState() => _UpdateStationScreenState();
}

class _UpdateStationScreenState extends State<UpdateStationScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  AddStationController addStationController = Get.put(AddStationController());

  UpdateStationController updateStationController =
      Get.put(UpdateStationController());

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
  bool showalternatenumber = false;
  void initState() {
    getstationDetails();
  }

  var selectedData;
  Future<void> getstationDetails() async {
    await updateStationController
        .stationDetailsFun(widget.stationId.toString(), user_token,
            isLoad: false)
        .then((val) {
      updateStationController.petrolStationNameC.text =
          updateStationController.stationFinalData.data!.stationName.toString();

      updateStationController.personNameC.text = updateStationController
          .stationFinalData.data!.contactPerson
          .toString();
      updateStationController.phoneNumberC.text = updateStationController
          .stationFinalData.data!.contactNumber
          .toString();
      if (updateStationController.stationFinalData.data!.alternateNumber
              .toString() ==
          '') {
        updateStationController.alternateNumberC.text = updateStationController
            .stationFinalData.data!.alternateNumber
            .toString();
      } else {
        showalternatenumber = true;
      }
      updateStationController.latitudeC.text =
          updateStationController.stationFinalData.data!.latitude.toString();
      updateStationController.longitudeC.text =
          updateStationController.stationFinalData.data!.longitude.toString();
      updateStationController.countryC.text =
          updateStationController.stationFinalData.data!.country.toString();
      updateStationController.alternateNumberC.text = updateStationController
          .stationFinalData.data!.alternateNumber
          .toString();
      updateStationController.stateC.text =
          updateStationController.stationFinalData.data!.state.toString();
      updateStationController.cityC.text =
          updateStationController.stationFinalData.data!.city.toString();
      updateStationController.addressC.text =
          updateStationController.stationFinalData.data!.address.toString();
      // updateStationController.pinCodeC.text =
      //     updateStationController.stationFinalData.data!.pincode.toString();
      // print(updateStationMangerController.managerFinalData);
      // print(
      //     'name=${updateStationMangerController.managerFinalData.data!.name}');
    });

    // updateStationMangerController.update();
  }

  Future<void> checkServiceAvilble() async {
    Map<String, dynamic> bodyData = {
      'latitude': updateStationController.latitudeC.text,
      'longitude': updateStationController.longitudeC.text,
    };
    print(bodyData);
    http.Response response = await http.post(
        Uri.parse(Constants.baseurl + "check_service_available"),
        body: bodyData);
    print(bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array

      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        saveFun();
      } else {
        Fluttertoast.showToast(
            // msg: jsonData['message'],
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

  saveFun() async {
    if (updateStationController.petrolStationNameC.text.isEmpty ||
        updateStationController.petrolStationNameC.text.length < 3) {
      setState(() {
        petrolStationError = true;
      });
    } else if (updateStationController.personNameC.text.isEmpty ||
        updateStationController.personNameC.text.length < 3) {
      setState(() {
        personNameError = true;
      });
    } else if (updateStationController.phoneNumberC.text.isEmpty) {
      setState(() {
        phoneNumberError = true;
      });
    } else if (updateStationController.countryC.text.isEmpty ||
        updateStationController.countryC.text.length < 3) {
      setState(() {
        countryError = true;
      });
    } else if (updateStationController.stateC.text.isEmpty ||
        updateStationController.stateC.text.length < 3) {
      setState(() {
        stateError = true;
      });
    } else if (updateStationController.cityC.text.isEmpty ||
        updateStationController.cityC.text.length < 3) {
      setState(() {
        cityError = true;
      });
    }
    //  else if (updateStationController.pinCodeC.text.isEmpty ||
    //     updateStationController.personNameC.text.length < 2) {
    //   setState(() {
    //     pincodeError = true;
    //   });
    // }
    else if (updateStationController.addressC.text.isEmpty ||
        updateStationController.addressC.text.length < 3) {
      setState(() {
        colonyError = true;
      });
    } else {
      print('goi');
      await updateStationController.validateAddStationFun(
          user_token.toString(),
          updateStationController.petrolStationNameC.text,
          updateStationController.personNameC.text,
          updateStationController.phoneNumberC.text,
          updateStationController.alternateNumberC.text,
          updateStationController.countryC.text,
          updateStationController.stateC.text,
          updateStationController.cityC.text,
          // updateStationController.pinCodeC.text,
          updateStationController.addressC.text,
          updateStationController.latitudeC.text,
          updateStationController.longitudeC.text,
          updateStationController.landmarkC.text,
          widget.stationId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom.commonAppBarCustom(context, title: 'Update Station',
          onTaped: () {
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
              CommonTextFieldTitle(title: 'Petrol Station Name'),
              SizedBox(
                height: 6,
              ),
              CommonTextFieldAuthentication(
                  controller: updateStationController.petrolStationNameC,
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
                  isErrorTextString: 'Please enter station name',
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
                  controller: updateStationController.personNameC,
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
                  isErrorTextString: 'Please enter person name',
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
                  controller: updateStationController.phoneNumberC,
                  hintText: 'Phone Number',
                  readOnlytext: false,
                  typeOfRed: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
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
          (showalternatenumber == true)
              ? Align(
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
                )
              : SizedBox(
                  height: 10,
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
                    controller: updateStationController.alternateNumberC,
                    hintText: 'Alternate Number',
                    readOnlytext: false,
                    typeOfRed: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-z A-Z 0-9 @ - / .]")),
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
                builder: (context) => UpdateStationLocation(),
              ));
              print('address coming');
              print(selectedaddress);
              if (selectedaddress['latitude'] != null) {
                setState(() {
                  selectedData = selectedaddress;
                  updateStationController.countryC.text =
                      selectedData['country'].toString();
                  updateStationController.stateC.text =
                      selectedData['state'].toString();
                  // updateStationController.pinCodeC.text =
                  //     selectedData['postalCode'].toString();
                  updateStationController.cityC.text =
                      selectedData['locality'].toString();
                  updateStationController.addressC.text =
                      selectedData['street'].toString();
                  updateStationController.latitudeC.text =
                      selectedData['latitude'].toString();
                  updateStationController.longitudeC.text =
                      selectedData['longitude'].toString();
                });
              }

              // Get.to(() => UseMyLocationScreen(),
              //     transition: Transition.rightToLeft,
              //     duration: const Duration(milliseconds: 400))
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
                        controller: updateStationController.countryC,
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
                    CommonTextFieldTitle(title: 'State'),
                    SizedBox(
                      height: 6,
                    ),
                    CommonTextFieldAuthentication(
                        controller: updateStationController.stateC,
                        hintText: 'State',
                        readOnlytext: true,
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
                        controller: updateStationController.cityC,
                        hintText: 'City',
                        readOnlytext: true,
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
              //           controller: updateStationController.pinCodeC,
              //           hintText: 'Pin code',
              //           readOnlytext: true,
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
                  controller: updateStationController.addressC,
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
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton.icon(
          //     onPressed: () => setState(() {
          //       isLandmark = !isLandmark;
          //     }),
          //     icon: Icon(
          //       Icons.add_circle_sharp,
          //       color: Color(0xFF2874F0),
          //       size: 20,
          //     ),
          //     label: Text(
          //       'Add nearby famous land mark',
          //       style: GoogleFonts.roboto(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w400,
          //         color: Color(0xFF2874F0),
          //       ),
          //     ),
          //   ),
          // ),
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
                    controller: updateStationController.landmarkC,
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
          SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () => addStationController.isAddStationLoading.value
                  ? null
                  : checkServiceAvilble(),
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
    );
  }
}
