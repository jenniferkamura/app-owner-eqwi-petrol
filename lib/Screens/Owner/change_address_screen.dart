// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/common_widgets/common_text_field_widget.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_cart_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_screen.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'package:owner_eqwi_petrol/Screens/Owner/cart_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/update_station.dart';
import 'dart:convert' as convert;

class ChangeAddressScreen extends StatefulWidget {
  final Function notificationsCountFun_value;
  ChangeAddressScreen({Key? key, required this.notificationsCountFun_value})
      : super(key: key);

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  int stationsCount = 0;
  List<dynamic> stations = [];
  List<dynamic> stationslist = [];
  bool isLoader = false;
  bool apirequest = false;
  String? selectStationId;
  String? station_id;
  bool isloading = false;
  void initState() {
    getstationslist();
  }

  var selectedstation;
  updateStation() {
    print(selectStationId);
    if (selectStationId == null || selectStationId == '') {
      Fluttertoast.showToast(
          // msg: jsonData['message'],
          msg: "Please select petrol station",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to right, #6db000 #6db000)",
          //  backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      for (var i = 0; i < stationslist.length; i++) {
        print(stationslist[i]['station_id']);
        if (selectStationId == stationslist[i]['station_id']) {
          setState(() {
            selectedstation = stationslist[i];
            print('stationsslist');
            print(selectedstation);
          });
          Navigator.pop(context, selectedstation);
        }

        //    print(stationslist[i]);
      }
    }
  }

  Future<void> getstationslist() async {
    stationslist.clear();
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
    };
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "stations"), body: bodyData);
    print('body data');
    print(bodyData);
    print('isloader: $isLoader');
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      print(result);
      setState(() {
        isLoader = false;
      });
      apirequest = true;
      if (result['status'] == 'success') {
        if (result['data'] == null ||
            result['data'] == '' ||
            result['data'].length == 0) {
          stationslist.clear();
        } else {
          stationslist.clear();
          setState(() {
            stationslist = result['data'];
            selectStationId = stationslist[0]['station_id'];
            print(selectStationId);
            stationsCount = result['data'].length;
            //   managersCount = result['data']['total_records_count'];
          });
        }
      } else if (result['status'] == 'error') {
        setState(() {
          stationsCount = 0;
        });
      }
    }
  }

  Future<void> deleteStation(station_id) async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
      'station_id': station_id.toString(),
    };
    print(bodyData);
    setState(() {
      isLoader = true;
    });
    http.Response response = await http
        .post(Uri.parse(Constants.baseurl + "delete_station"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        setState(() {
          isLoader = false;
        });
        Navigator.of(context).pop();
        getstationslist();
      } else {}
    }
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    //Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          backgroundColor: AppColor.appThemeColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Petrol Stations',
            style: CustomTextWhiteStyle.textStyleWhite(
                context, 18, FontWeight.w600),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartScreen(
                            notificationsCountFun_value: () =>
                                widget.notificationsCountFun_value())));
                Get.back();
              },
              color: Colors.white,
              textColor: Colors.white,
              padding: const EdgeInsets.all(8),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddCartStationScreen(),
                      ));
                    },
                    child: Text(
                      'Add Station',
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ))
          ],
        ),
        body: isLoader == false
            ? ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                  //   height: 1,
                  //   color: Color(0xFFC4C4C4),
                  // ),
                  // SizedBox(
                  //   height: 16,
                  // ),
                  (stationsCount != 0)
                      ? ListView.builder(
                          itemCount: stationslist.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          activeColor: AppColor.appThemeColor,
                                          value: stationslist[index]
                                              ['station_id'],
                                          groupValue: selectStationId,
                                          onChanged: (value) {
                                            setState(() {
                                              selectStationId =
                                                  value.toString();
                                            });
                                          }),
                                      // Image.asset(
                                      //   index == 0
                                      //       ? '${StringConstatnts.assets}select.png'
                                      //       : '${StringConstatnts.assets}unchecked.png',
                                      //   color: index == 0
                                      //       ? AppColor.appThemeColor
                                      //       : Color(0xFF878787),
                                      //   height: 18,
                                      // ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        stationslist[index]['station_name']
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF878787)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 26, top: 4),
                                    child: Text(
                                      stationslist[index]['contact_person']
                                          .toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 26, top: 5),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          '${StringConstatnts.assets}mobile.png',
                                          height: 16,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          stationslist[index]['contact_number']
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 26, top: 5),
                                    child: Text(
                                      '${stationslist[index]['address']},${stationslist[index]['state']},${stationslist[index]['country']},${stationslist[index]['pincode']}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF878787)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 26, top: 5),
                                    child: Text(
                                      'District: ${stationslist[index]['city'].toString()}',
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF878787)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 26, top: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${stationslist[index]['country'].toString()} - ${stationslist[index]['pincode'].toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF878787)),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            deleteFunction(
                                                context,
                                                stationslist[index]
                                                    ['station_id']);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                                UpdateStationScreen(
                                                    stationId:
                                                        stationslist[index]
                                                            ['station_id']),
                                                transition:
                                                    Transition.rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 400));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 45,
                                            height: 24,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColor.appThemeColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Text(
                                              'Edit',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF8D8D8D)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                    ),
                                    height: 1,
                                    color: Color(0xFFC4C4C4),
                                  ),
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 100),
                            child: Text('No Petrol Stations Found',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Mulish semibold",
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                  if (stationsCount != 0)
                    Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: isloading == false
                            ? ElevatedButton(
                                onPressed: () {
                                  updateStation();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                                child: Text(
                                  'update'.toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: "ROBOTO",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {},
                                child: Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.blackColor,
                                    fixedSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(48 / 2),
                                    )),
                              )),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 16, right: 16, top: 45, bottom: 45),
                  //     alignment: Alignment.center,
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       color: AppColor.blackColor,
                  //       borderRadius: BorderRadius.circular(48 / 2),
                  //     ),
                  //     child: Text(
                  //       'update'.toUpperCase(),
                  //       style: GoogleFonts.roboto(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //           color: AppColor.whiteColor),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : Center(
                child: Container(
                  child: CircularProgressIndicator(
                      color: AppColor.appThemeColor, strokeWidth: 3),
                ),
              ),
      ),
    );
  }

  void deleteFunction(context, station_id) {
    print(station_id);
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Are you sure do you want delete?',
                    style: GoogleFonts.baloo2(
                        textStyle: Theme.of(context).textTheme.displayMedium,
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        deleteStation(station_id);
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        });
  }
}
