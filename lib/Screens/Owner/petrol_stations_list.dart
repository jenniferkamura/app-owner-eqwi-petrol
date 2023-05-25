// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'package:owner_eqwi_petrol/Screens/Owner/update_station.dart';
import 'dart:convert' as convert;
import '../../Common/common_widgets/common_text_field_widget.dart';
import '../../Common/constants.dart';

class PetrolStationsScreen extends StatefulWidget {
  PetrolStationsScreen({Key? key}) : super(key: key);

  @override
  State<PetrolStationsScreen> createState() => _PetrolStationsScreenState();
}

class _PetrolStationsScreenState extends State<PetrolStationsScreen> {
  String? user_token = Constants.prefs?.getString('user_token');
  int stationsCount = 0;
  List<dynamic> stations = [];
  List<dynamic> stationslist = [];
  bool isLoader = false;
  bool apirequest = false;
  @override
  void initState() {
    getstationslist();
    super.initState();
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
        .post(Uri.parse("${Constants.baseurl}stations"), body: bodyData);
    // print('body data');
    // print(bodyData);
    // print('isloader: $isLoader');
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //print(result);
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
            //  print(stationslist);
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
        .post(Uri.parse("${Constants.baseurl}delete_station"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      //    print(result);
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
                            builder: (context) => TabbarScreen()));
                    // Get.back();
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
                      padding:
                          const EdgeInsets.only(right: 15, top: 8, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddStationScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.blackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          'Add Station',
                          style: TextStyle(
                              fontFamily: "Mulish",
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
              ],
            ),
            body: isLoader == true
                ? Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 100),
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          color: AppColor.appThemeColor, strokeWidth: 3),
                    ),
                  )
                : ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              stationslist[index]
                                                      ['station_name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF878787)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
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
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
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
                                              stationslist[index]
                                                      ['contact_number']
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
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
                                        child: Text(
                                          '${stationslist[index]['address']},${stationslist[index]['state']},${stationslist[index]['country']},${stationslist[index]['pincode']}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF878787)),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
                                        child: Text(
                                          'District: ${stationslist[index]['city'].toString()}',
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF878787)),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${stationslist[index]['country'].toString()}',
                                              //  - ${stationslist[index]['pincode'].toString()}'

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
                                                      color: AppColor
                                                          .appThemeColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Text(
                                                  'Edit',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                            )
                    ],
                  )));
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
