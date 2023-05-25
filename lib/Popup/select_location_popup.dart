// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/constants.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SelectLocationPopup extends StatefulWidget {
  const SelectLocationPopup({super.key});

  @override
  State<SelectLocationPopup> createState() => _SelectLocationPopupState();
}

class _SelectLocationPopupState extends State<SelectLocationPopup> {
  // ignore: non_constant_identifier_names
  String? user_token = Constants.prefs?.getString('user_token');
  int stationsCount = 0;
  List<dynamic> stations = [];
  List<dynamic> stationslist = [];
  bool isLoader = false;
  bool isSelect = true;
  String? selectStationId;
  // ignore: non_constant_identifier_names
  String? station_id;

  @override
  void initState() {
    super.initState();
    getstationslist();
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

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);

      setState(() {
        isLoader = false;
      });
      // print(result);

      if (result['status'] == 'success') {
        if (result['data'] == null ||
            result['data'] == '' ||
            result['data'].length == 0) {
          stationslist.clear();
        } else {
          stationslist.clear();
          setState(() {
            stationslist = result['data'];
            // selectStationId = stationslist[0]['station_id'];
            print(stationslist);
            stationsCount = result['data'].length;
            print('shared station id: ');
            print(Constants.prefs?.getString('selectStationId'));
            if (Constants.prefs?.getString('selectStationId') != null ||
                Constants.prefs?.getString('selectStationId') != '') {
              print('going if condition');
              selectStationId = Constants.prefs?.getString('selectStationId');
              //
              for (var i = 0; i < result['data'].length; i++) {
                if (selectStationId == result['data'][i]['station_id']) {
                  selectedstation = result['data'][i];
                  selectStationId = result['data'][i]['station_id'];
                }
              }
            } else {
              print('going else  condition');
              selectStationId = stationslist[0]['station_id'];
              for (var i = 0; i < result['data'].length; i++) {
                if (selectStationId == result['data'][i]['station_id']) {
                  selectedstation = result['data'][i];
                  selectStationId = result['data'][i]['station_id'];
                }
              }
            }
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

  // ignore: prefer_typing_uninitialized_variables
  var selectedstation;

  updateStation() {
    print(selectStationId);
    Constants.prefs?.setString('selectStationId', selectStationId.toString());
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
        // print(stationslist[i]['station_id']);
        if (selectStationId == stationslist[i]['station_id']) {
          setState(() {
            selectedstation = stationslist[i];
          });
          Navigator.pop(context, selectedstation);
        }
      }
      print('selectedstation');
      print(selectedstation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 353,
          margin: EdgeInsets.only(
              top: 60,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).size.height / 2.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 17, left: 11, right: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Location',
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //   height: 35,
                    //   decoration: BoxDecoration(
                    //     color: AppColor.appThemeColor.withOpacity(0.12),
                    //     borderRadius: BorderRadius.circular(3),
                    //   ),
                    //   // child: TextField(
                    //   //   textAlign: TextAlign.start,
                    //   //   decoration: InputDecoration(
                    //   //     border: InputBorder.none,
                    //   //     hintText: 'Type your location, landmark...',
                    //   //     hintStyle: TextStyle(
                    //   //       fontFamily: fontName,
                    //   //       fontSize: 14,
                    //   //       fontWeight: FontWeight.w400,
                    //   //       color: Color(0xFFA0A0A0),
                    //   //     ),
                    //   //     prefixIcon: Padding(
                    //   //       padding: const EdgeInsets.all(8.0),
                    //   //       child: Image.asset(
                    //   //         '${StringConstatnts.assets}search.png',
                    //   //       ),
                    //   //     ),
                    //   //   ),
                    //   // ),
                    // ),
                    isLoader == false
                        ? ListView.builder(
                            itemCount: stationslist.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return (stationsCount > 0)
                                  ? Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //select
                                              GestureDetector(
                                                onTap: () {
                                                  if (mounted) {
                                                    setState(() {
                                                      isSelect = true;
                                                    });
                                                  }
                                                },
                                                child: InkWell(
                                                  onTap: (() {
                                                    setState(() {
                                                      selectStationId =
                                                          stationslist[index]
                                                              ['station_id'];
                                                    });
                                                    updateStation();
                                                  }),
                                                  child: Image.asset(
                                                    selectStationId ==
                                                            stationslist[index]
                                                                ['station_id']
                                                        ? '${StringConstatnts.assets}select.png'
                                                        : '${StringConstatnts.assets}unchecked.png',
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              InkWell(
                                                onTap: (() {
                                                  setState(() {
                                                    selectStationId =
                                                        stationslist[index]
                                                            ['station_id'];
                                                  });
                                                  updateStation();
                                                }),
                                                child: Text(
                                                  stationslist[index]
                                                          ['station_name']
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColor.blackColor),
                                                ),
                                              ),

                                              // Container(
                                              //   decoration: BoxDecoration(
                                              //       color: AppColor.appColorD4D4D4,
                                              //       borderRadius:
                                              //           BorderRadius.circular(3)),
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.all(6.0),
                                              //     child: Text(
                                              //       'Petrol Station 1',
                                              //       style: GoogleFonts.roboto(
                                              //           fontSize: 12,
                                              //           fontWeight: FontWeight.w400,
                                              //           color: AppColor.appColor595959),
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          InkWell(
                                            onTap: (() {
                                              setState(() {
                                                selectStationId =
                                                    stationslist[index]
                                                        ['station_id'];
                                                print('selectStationId');
                                                print(selectStationId);
                                              });
                                              updateStation();
                                            }),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 17, top: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Text(
                                                  '${stationslist[index]['address']},${stationslist[index]['state']},${stationslist[index]['country']},${stationslist[index]['pincode']}',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColor
                                                          .appColor595959),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                          'No Station Found,Please add stations'),
                                    );
                            })
                        : Center(
                            child: CircularProgressIndicator(
                                color: AppColor.appThemeColor, strokeWidth: 3),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
