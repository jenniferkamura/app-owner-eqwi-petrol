import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owner_eqwi_petrol/Common/app_color.dart';
import 'package:owner_eqwi_petrol/Common/string_constants.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_attender_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/add_station_manager_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/edit_attender_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/edit_station_manger_screen.dart';
import 'package:owner_eqwi_petrol/Screens/Owner/tabbar_screen.dart';

import '../../Common/common_app_bar.dart';
import '../../Common/common_widgets/common_text_field_widget.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart' as convert;
import 'dart:convert' as convert;
import '../../Common/constants.dart';

class AttenderMangement extends StatefulWidget {
  const AttenderMangement({super.key});

  @override
  State<AttenderMangement> createState() => _AttenderMangementState();
}

class _AttenderMangementState extends State<AttenderMangement> {
  String? user_token = Constants.prefs?.getString('user_token');
  int managersCount = 0;
  List<dynamic> managers = [];
  List<dynamic> managerslist = [];
  bool isLoader = false;
  @override
  void initState() {
    super.initState();
    getattenderlist();
  }

  Future<void> getattenderlist() async {
    managerslist.clear();
    setState(() {
      isLoader = true;
    });
    Map<String, dynamic> bodyData = {
      'user_token': user_token.toString(),
      'user_type': 'Attendant',
    };
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}manager_list"), body: bodyData);
    print('body data');
    print(bodyData);

    print('isloader: $isLoader');
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      //  print(result);
      setState(() {
        isLoader = false;
      });
      if (result['status'] == 'success') {
        if (result['data']['result'] == null ||
            result['data']['result'] == '' ||
            result['data']['result'].length == 0) {
          managerslist.clear();

          print(managersCount);
        } else {
          managerslist.clear();
          setState(() {
            managerslist = result['data']['result'];
            managersCount = result['data']['total_records_count'];
            print(managerslist);
          });
        }
      } else if (result['status'] == 'error') {
        setState(() {
          managersCount = 0;
        });
      }
    }
  }

  Future<void> deleteManager(manager_id) async {
    Map<String, dynamic> bodyData = {
      'user_token': user_token,
      'manager_id': manager_id.toString(),
    };
    print(bodyData);
    setState(() {
      isLoader = true;
    });
    http.Response response = await http
        .post(Uri.parse("${Constants.baseurl}delete_manager"), body: bodyData);
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      // dart array
      //  print(result);
      if (result['status'] == 'success') {
        // reidrect to login Page
        setState(() {
          isLoader = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        getattenderlist();
      } else {}
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TabbarScreen()));
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
              "Attender Management",
              style: CustomTextWhiteStyle.textStyleWhite(
                  context, 18, FontWeight.w600),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TabbarScreen()));
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
                          builder: (context) => const AddAttenderScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: const Text(
                        'Add Attender',
                        style: TextStyle(
                            fontFamily: "Mulish",
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ))
            ],
          ),
          body: isLoader == false
              ? ListView(children: [
                  (managersCount != 0)
                      ? Container(
                          margin: const EdgeInsets.only(left: 16, top: 24),
                          child: Text(
                            'Attenders List',
                            style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor),
                          ),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  (managersCount != 0)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: managerslist.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(
                                bottom: 12, left: 16, right: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF89A619),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 13, left: 10, top: 10, right: 10),
                              child: Row(
                                children: [
                                  Image.network(
                                    managerslist[index]['profile_pic_url']
                                        .toString(),
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        managerslist[index]['name'].toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF656565),
                                        ),
                                      ),
                                      Text(
                                        managerslist[index]['address']
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF656565),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          //Get.back();
                                          Get.to(
                                              UpdateAttender(
                                                  managerId: managerslist[index]
                                                      ['user_id']),
                                              transition:
                                                  Transition.rightToLeft,
                                              duration: const Duration(
                                                  milliseconds: 400));
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Edit',
                                              style: GoogleFonts.roboto(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF818181),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: Color(0xFF818181),
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          deleteFunction(context,
                                              managerslist[index]['user_id']);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Delete',
                                              style: GoogleFonts.roboto(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF818181),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                                '${StringConstatnts.assets}delete_.png'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: const Text('No Attenders Found',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Mulish semibold",
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                ])
              : Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: AppColor.appThemeColor, strokeWidth: 3),
                  ),
                )),
    );
  }

  void deleteFunction(context, manger_id) {
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
                        deleteManager(manger_id);
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
